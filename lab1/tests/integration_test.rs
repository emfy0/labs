use lib1::priority_queue::PriorityQueue;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn new() {
        let result: PriorityQueue<u64> = PriorityQueue::new();

        assert_eq!(result.len(), 0);
        assert_eq!(result.is_empty(), true);
    }

    #[test]
    fn push() {
        let mut result = PriorityQueue::new();
        result.push(3);
        result.push(7);
        result.push(5);
        result.push(6);

        assert_eq!(result.first(), Some(&7));
        assert_eq!(result.len(), 4);
        assert_eq!(result.is_empty(), false);

        assert_eq!(result.pop(), Some(7));
        assert_eq!(result.first(), Some(&6));
        assert_eq!(result.pop(), Some(6));
        assert_eq!(result.first(), Some(&5));
        assert_eq!(result.pop(), Some(5));
        assert_eq!(result.first(), Some(&3));
        assert_eq!(result.pop(), Some(3));
        assert_eq!(result.pop(), None);
        assert_eq!(result.is_empty(), true);
    }

    #[test]
    fn from_vec() {
        let mut result = PriorityQueue::from_vec(vec![1, 5, 3, 2, 8]);

        assert_eq!(result.first(), Some(&8));
        assert_eq!(result.len(), 5);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some(8));

        assert_eq!(result.first(), Some(&5));
        assert_eq!(result.len(), 4);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some(5));

        assert_eq!(result.first(), Some(&3));
        assert_eq!(result.len(), 3);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some(3));

        assert_eq!(result.first(), Some(&2));
        assert_eq!(result.len(), 2);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some(2));

        assert_eq!(result.first(), Some(&1));
        assert_eq!(result.len(), 1);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some(1));

        assert_eq!(result.first(), None);
        assert_eq!(result.len(), 0);
        assert_eq!(result.is_empty(), true);
        assert_eq!(result.pop(), None);
    }

    #[test]
    fn from_vec_of_chars() {
        let mut result = PriorityQueue::from_vec(vec!["b", "a", "d", "c"]);

        assert_eq!(result.first(), Some(&"d"));
        assert_eq!(result.len(), 4);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some("d"));

        assert_eq!(result.first(), Some(&"c"));
        assert_eq!(result.len(), 3);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some("c"));

        assert_eq!(result.first(), Some(&"b"));
        assert_eq!(result.len(), 2);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some("b"));

        assert_eq!(result.first(), Some(&"a"));
        assert_eq!(result.len(), 1);
        assert_eq!(result.is_empty(), false);
        assert_eq!(result.pop(), Some("a"));

        assert_eq!(result.first(), None);
        assert_eq!(result.len(), 0);
        assert_eq!(result.is_empty(), true);
        assert_eq!(result.pop(), None);
    }
}
