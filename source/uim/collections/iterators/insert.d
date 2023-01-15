module uim.collections.iterators;

import uim.collections.Collection;

/**
 * This iterator will insert values into a property of each of the records returned.
 * The values to be inserted come out of another traversal object. This is useful
 * when you have two separate collections and want to merge them together by placing
 * each of the values from one collection into a property inside the other collection.
 */
class DCOLInsertIterator : Collection {
    // The collection from which to extract the values to be inserted
    protected DCOLCollection _values;

    // Holds whether the values collection is still valid. (has more records)
    protected bool _validValues = true;

    /**
     * An array containing each of the properties to be traversed to reach the
     * point where the values should be inserted.
     */
    protected string[] _path;

    /**
     * The property name to which values will be assigned
     */
    protected string _target;

    /**
     * Constructs a new collection that will dynamically add properties to it out of
     * the values found in $values.
     *
     * @param iterable $into The target collection to which the values will
     * be inserted at the specified path.
     * @param string $path A dot separated list of properties that need to be traversed
     * to insert the value into the target collection.
     * @param iterable $values The source collection from which the values will
     * be inserted at the specified path.
     */
    this(iterable $into, string $path, iterable $values) {
        super(($into);

        if (!($values instanceof Collection)) {
            $values = new Collection($values);
        }

        $path = explode(".", $path);
        $target = array_pop($path);
        _path = $path;
        _target = $target;
        _values = $values;
    }

    // Advances the cursor to the next record
    void next() {
        super.next();
        if (_validValues) {
            _values.next();
        }
        _validValues = _values.valid();
    }

    /**
     * Returns the current element in the target collection after inserting
     * the value from the source collection into the specified path.
     *
     * @return mixed
     */
    #[\ReturnTypeWillChange]
    function current() {
        $row = super.current();

        if (!_validValues) {
            return $row;
        }

        $pointer = &$row;
        foreach (_path as $step) {
            if (!isset($pointer[$step])) {
                return $row;
            }
            $pointer = &$pointer[$step];
        }

        $pointer[_target] = _values.current();

        return $row;
    }

    /**
     * Resets the collection pointer.
     */
    void rewind() {
        super.rewind();
        _values.rewind();
        _validValues = _values.valid();
    }
}
