#[derive(Debug)]
pub struct PriorityQueue<T> {
    array: Vec<T>,
}

impl<T: std::cmp::Ord + Copy> PriorityQueue<T> {
    pub fn new() -> Self {
        Self { array: Vec::new() }
    }

    pub fn from_vec(mut vec: Vec<T>) -> Self
    where
        T: Copy,
    {
        let mut queue = Self::new();
        vec.iter_mut().for_each(|e| queue.push(*e));

        queue
    }

    pub fn push(&mut self, value: T)
    where
        T: PartialOrd + Copy,
    {
        self.array.push(value);
        self.bottom_heapfiy(self.array.len() - 1);
    }

    pub fn pop(&mut self) -> Option<T> {
        let mut array_len = self.array.len();

        if array_len == 0 {
            return None;
        }

        if array_len == 1 {
            return self.array.pop();
        }

        array_len = array_len - 1;
        self.array.swap(0, array_len);
        let data = self.array.remove(array_len);

        self.top_heapify(0, array_len - 1);

        Some(data)
    }

    pub fn first(&self) -> Option<&T> {
        self.array.get(0)
    }

    pub fn len(&self) -> usize {
        self.array.len()
    }

    pub fn is_empty(&self) -> bool {
        self.array.is_empty()
    }

    fn top_heapify(&mut self, element_index: usize, array_size: usize) {
        let left_child_index = Self::left_child_index(element_index);
        let right_child_index = Self::right_child_index(element_index);

        let mut greatest_element_index = element_index;

        if self.array.get(left_child_index) > self.array.get(element_index) {
            greatest_element_index = left_child_index
        };
        if self.array.get(right_child_index) > self.array.get(element_index) {
            greatest_element_index = right_child_index
        };

        if greatest_element_index == element_index {
            return;
        }

        self.array.swap(greatest_element_index, element_index);
        self.top_heapify(element_index, array_size)
    }

    fn bottom_heapfiy(&mut self, element_index: usize) {
        if element_index == 0 {
            return;
        }

        let head_element_index = (element_index + element_index % 2 - 2) / 2;

        if self.array.get(element_index) <= self.array.get(head_element_index) {
            return;
        }

        self.array.swap(head_element_index, element_index);
        self.bottom_heapfiy(head_element_index)
    }

    fn left_child_index(i: usize) -> usize {
        2 * i + 1
    }

    fn right_child_index(i: usize) -> usize {
        2 * i + 2
    }
}
