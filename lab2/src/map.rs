use std::borrow::Borrow;
use std::cmp::Ordering::*;
use std::mem;

#[derive(Debug, Clone)]
pub enum Map<K: Clone, V: Clone> {
    Empty,
    NonEmpty(Box<Node<K, V>>),
}
use Map::*;

#[derive(Debug, Clone)]
pub struct Node<K: Clone, V: Clone> {
    pub key: K,
    pub value: V,
    pub left: Map<K, V>,
    pub right: Map<K, V>,
    balance_factor: i8,
}

impl<K, V> Drop for Map<K, V>
where
    K: Clone,
    V: Clone,
{
    fn drop(&mut self) {
        drop(self)
    }
}

impl<K, V> Map<K, V>
where
    K: Ord + Clone,
    V: Clone,
{
    pub fn new() -> Self {
        Empty
    }

    pub fn from_map(map: &Map<K, V>) -> Self {
        map.clone()
    }

    pub fn insert(&mut self, key: K, value: V) -> bool {
        self.add(key, value).0
    }

    pub fn len(&self) -> usize {
        match *self {
            Empty => 0,
            NonEmpty(ref v) => 1 + v.left.len() + v.right.len(),
        }
    }

    pub fn is_empty(&self) -> bool {
        match *self {
            Empty => true,
            _ => false,
        }
    }

    pub fn get<Q>(&self, key: &Q) -> Option<&V>
    where
        K: Borrow<Q>,
        Q: Ord,
    {
        match *self {
            Empty => None,
            NonEmpty(ref node) => match key.cmp(node.key.borrow()) {
                Less => node.left.get(key),
                Equal => Some(&node.value),
                Greater => node.right.get(key),
            },
        }
    }

    pub fn clear(&mut self) {
        drop(&*self);
        *self = Empty;
    }

    fn add(&mut self, key: K, value: V) -> (bool, bool) {
        // returns: (inserted, deepened)
        let ret = match *self {
            Empty => {
                let node = Node {
                    key,
                    value,
                    left: Empty,
                    right: Empty,
                    balance_factor: 0,
                };
                *self = NonEmpty(Box::new(node));
                (true, true)
            }
            NonEmpty(ref mut node) => match node.key.cmp(&key) {
                Equal => (false, false),
                Less => {
                    let (inserted, deepened) = node.right.add(key, value);
                    if deepened {
                        let ret = match node.balance_factor {
                            -1 => (inserted, false),
                            0 => (inserted, true),
                            1 => (inserted, false),
                            _ => unreachable!(),
                        };
                        node.balance_factor += 1;
                        ret
                    } else {
                        (inserted, deepened)
                    }
                }
                Greater => {
                    let (inserted, deepened) = node.left.add(key, value);
                    if deepened {
                        let ret = match node.balance_factor {
                            -1 => (inserted, false),
                            0 => (inserted, true),
                            1 => (inserted, false),
                            _ => unreachable!(),
                        };
                        node.balance_factor -= 1;
                        ret
                    } else {
                        (inserted, deepened)
                    }
                }
            },
        };
        self.balance();
        ret
    }

    fn balance(&mut self) {
        match *self {
            Empty => (),
            NonEmpty(_) => match self.node().balance_factor {
                -2 => {
                    let lf = self.node().left.node().balance_factor;
                    if lf == -1 || lf == 0 {
                        let (a, b) = if lf == -1 { (0, 0) } else { (-1, 1) };
                        self.rotate_right();
                        self.node().right.node().balance_factor = a;
                        self.node().balance_factor = b;
                    } else if lf == 1 {
                        let (a, b) = match self.node().left.node().right.node().balance_factor {
                            -1 => (1, 0),
                            0 => (0, 0),
                            1 => (0, -1),
                            _ => unreachable!(),
                        };
                        self.node().left.rotate_left();
                        self.rotate_right();
                        self.node().right.node().balance_factor = a;
                        self.node().left.node().balance_factor = b;
                        self.node().balance_factor = 0;
                    } else {
                        unreachable!()
                    }
                }
                2 => {
                    let lf = self.node().right.node().balance_factor;
                    if lf == 1 || lf == 0 {
                        let (a, b) = if lf == 1 { (0, 0) } else { (1, -1) };
                        self.rotate_left();
                        self.node().left.node().balance_factor = a;
                        self.node().balance_factor = b;
                    } else if lf == -1 {
                        let (a, b) = match self.node().right.node().left.node().balance_factor {
                            1 => (-1, 0),
                            0 => (0, 0),
                            -1 => (0, 1),
                            _ => unreachable!(),
                        };
                        self.node().right.rotate_right();
                        self.rotate_left();
                        self.node().left.node().balance_factor = a;
                        self.node().right.node().balance_factor = b;
                        self.node().balance_factor = 0;
                    } else {
                        unreachable!()
                    }
                }
                _ => (),
            },
        }
    }

    fn node(&mut self) -> &mut Node<K, V> {
        match *self {
            Empty => panic!("call on empty tree"),
            NonEmpty(ref mut v) => v,
        }
    }

    fn right(&mut self) -> &mut Self {
        match *self {
            Empty => panic!("call on empty tree"),
            NonEmpty(ref mut node) => &mut node.right,
        }
    }

    fn left(&mut self) -> &mut Self {
        match *self {
            Empty => panic!("call on empty tree"),
            NonEmpty(ref mut node) => &mut node.left,
        }
    }

    fn rotate_right(&mut self) {
        let mut v = mem::replace(self, Empty);
        let mut left = mem::replace(v.left(), Empty);
        let left_right = mem::replace(left.right(), Empty);
        *v.left() = left_right;
        *left.right() = v;
        *self = left;
    }

    fn rotate_left(&mut self) {
        let mut v = mem::replace(self, Empty);
        let mut right = mem::replace(v.right(), Empty);
        let right_left = mem::replace(right.left(), Empty);
        *v.right() = right_left;
        *right.left() = v;
        *self = right;
    }
}
