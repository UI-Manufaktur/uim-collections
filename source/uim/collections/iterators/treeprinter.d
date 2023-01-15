module uim.collections.iterators;

import uim.collections.ICollection;
import uim.collections.CollectionTrait;
use RecursiveIterator;
use RecursiveIteratorIterator;

/**
 * Iterator for flattening elements in a tree structure while adding some
 * visual markers for their relative position in the tree
 */
class TreePrinter : RecursiveIteratorIterator : ICollection {
    use CollectionTrait;

    /**
     * A callable to generate the iteration key
     *
     * @var callable
     */
    protected _key;

    /**
     * A callable to extract the display value
     *
     * @var callable
     */
    protected _value;

    /**
     * Cached value for the current iteration element
     *
     * @var mixed
     */
    protected _current;

    // The string to use for prefixing the values according to their depth in the tree.
    protected string _spacer;

    /**
     * Constructor
     *
     * @param \RecursiveIterator $items The iterator to flatten.
     * @param callable|string aValuePath The property to extract or a callable to return
     * the display value.
     * @param callable|string aKeyPath The property to use as iteration key or a
     * callable returning the key value.
     * @param string $spacer The string to use for prefixing the values according to
     * their depth in the tree.
     * @param int $mode Iterator mode.
     */
    this(
        RecursiveIterator $items,
        $valuePath,
        $keyPath,
        string $spacer,
        int $mode = RecursiveIteratorIterator::SELF_FIRST
    ) {
        super(($items, $mode);
        _value = _propertyExtractor($valuePath);
        _key = _propertyExtractor($keyPath);
        _spacer = $spacer;
    }

    /**
     * Returns the current iteration key
     *
     * @return mixed
     */
    #[\ReturnTypeWillChange]
    function key() {
        $extractor = _key;

        return $extractor(_fetchCurrent(), super.key(), this);
    }

    /**
     * Returns the current iteration value
     */
    string current() {
        $extractor = _value;
        $current = _fetchCurrent();
        $spacer = str_repeat(_spacer, this.getDepth());

        return $spacer . $extractor($current, super.key(), this);
    }

    /**
     * Advances the cursor one position
     */
    void next() {
        super.next();
        _current = null;
    }

    /**
     * Returns the current iteration element and caches its value
     *
     * @return mixed
     */
    protected function _fetchCurrent() {
        if (_current != null) {
            return _current;
        }

        return _current = super.current();
    }
}
