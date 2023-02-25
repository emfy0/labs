use lib2::map::Map;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn new() {
        let result: Map<u64, u64> = Map::new();

        assert_eq!(result.len(), 0);
        assert_eq!(result.is_empty(), true);
    }

    #[test]
    fn basic_functionality() {
        let mut map: Map<u64, String> = Map::new();

        assert_eq!(map.is_empty(), true);

        map.insert(1, String::from("first"));
        assert_eq!(map.is_empty(), false);

        map.insert(2, String::from("second"));
        map.insert(3, String::from("third"));
        map.insert(4, String::from("fourth"));

        assert_eq!(map.get(&2), Some(&String::from("second")));
        assert_eq!(map.get(&3), Some(&String::from("third")));
        assert_eq!(map.get(&4), Some(&String::from("fourth")));
        assert_eq!(map.get(&1), Some(&String::from("first")));
        assert_eq!(map.len(), 4);

        let clonned_map = Map::from_map(&map);
        assert_eq!(clonned_map.is_empty(), false);

        map.clear();
        assert_eq!(map.len(), 0);
        assert_eq!(map.is_empty(), true);
        drop(map);

        assert_eq!(clonned_map.get(&2), Some(&String::from("second")));
        assert_eq!(clonned_map.get(&3), Some(&String::from("third")));
        assert_eq!(clonned_map.get(&4), Some(&String::from("fourth")));
        assert_eq!(clonned_map.get(&1), Some(&String::from("first")));
        assert_eq!(clonned_map.len(), 4);
    }
}
