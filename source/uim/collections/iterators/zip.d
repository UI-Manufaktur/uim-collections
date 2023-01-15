module uim.collections.iterators;

import uim.collections.Collection;
import uim.collections.ICollection;
import uim.collections.CollectionTrait;
use MultipleIterator;
use Serializable;

/**
 * Creates an iterator that returns elements grouped in pairs
 *
 * ### Example
 *
 * ```
 *  $iterator = new ZipIterator([[1, 2], [3, 4]]);
 *  $iterator.toList(); // Returns [[1, 3], [2, 4]]
 * ```
 *
 * You can also chose a custom function to zip the elements together, such
 * as doing a sum by index:
 *
 * ### Example
 *
 * ```
 *  $iterator = new ZipIterator([[1, 2], [3, 4]], function ($a, $b) {
 *    return $a + $b;
 *  });
 *  $iterator.toList(); // Returns [4, 6]
 * ```
 */
class ZipIterator : MultipleIterator : ICollection, Serializable
{
    use CollectionTrait;

    /**
     * The function to use for zipping items together
     *
     * @var callable|null
     */
    protected _callback;

    /**
     * Contains the original iterator objects that were attached
     *
     * @var array
     */
    protected _iterators = null;

    /**
     * Creates the iterator to merge together the values by for all the passed
     * iterators by their corresponding index.
     *
     * @param array $sets The list of array or iterators to be zipped.
     * @param callable|null $callable The function to use for zipping the elements of each iterator.
     */
    this(array $sets, ?callable $callable = null) {
        $sets = array_map(function ($items) {
            return (new Collection($items)).unwrap();
        }, $sets);

        _callback = $callable;
        super((MultipleIterator::MIT_NEED_ALL | MultipleIterator::MIT_KEYS_NUMERIC);

        foreach ($sets as $set) {
            _iterators ~= $set;
            this.attachIterator($set);
        }
    }

    /**
     * Returns the value resulting out of zipping all the elements for all the
     * iterators with the same positional index.
     *
     * @return array
     */
    #[\ReturnTypeWillChange]
    function current() {
        if (_callback == null) {
            return super.current();
        }

        return call_user_func_array(_callback, super.current());
    }

    /**
     * Returns a string representation of this object that can be used
     * to reconstruct it
     */
    string serialize() {
        return serialize(_iterators);
    }

    /**
     * Magic method used for serializing the iterator instance.
     */
    array __serialize() {
        return _iterators;
    }

    /**
     * Unserializes the passed string and rebuilds the ZipIterator instance
     *
     * @param string $iterators The serialized iterators
     */
    void unserialize($iterators) {
        super((MultipleIterator::MIT_NEED_ALL | MultipleIterator::MIT_KEYS_NUMERIC);
        _iterators = unserialize($iterators);
        foreach (_iterators as $it) {
            this.attachIterator($it);
        }
    }

    /**
     * Magic method used to rebuild the iterator instance.
     *
     * @param array $data Data array.
     */
    void __unserialize(array $data) {
        super((MultipleIterator::MIT_NEED_ALL | MultipleIterator::MIT_KEYS_NUMERIC);

        _iterators = $data;
        foreach (_iterators as $it) {
            this.attachIterator($it);
        }
    }
}
