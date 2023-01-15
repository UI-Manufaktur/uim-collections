/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.collections.iterators.extract;

/* use ArrayIterator;
use Traversable; */

/**
 * Creates an iterator from another iterator that extract the requested column
 * or property based on a path
 */
class ExtractIterator : Collection {
    /**
     * A callable responsible for extracting a single value for each
     * item in the collection.
     *
     * @var callable
     */
    protected _extractor;

    /**
     * Creates the iterator that will return the requested property for each value
     * in the collection expressed in $path
     *
     * ### Example:
     *
     * Extract the user name for all comments in the array:
     *
     * ```
     * $items = [
     *  ["comment": ["body": "cool", "user": ["name": "Mark"]],
     *  ["comment": ["body": "very cool", "user": ["name": "Renan"]]
     * ];
     * $extractor = new ExtractIterator($items, "comment.user.name"");
     * ```
     *
     * @param iterable $items The list of values to iterate
     * @param callable|string $path A dot separated path of column to follow
     * so that the final one can be returned or a callable that will take care
     * of doing that.
     */
    this(iterable $items, $path) {
        _extractor = _propertyExtractor($path);
        super(($items);
    }

    /**
     * Returns the column value defined in $path or null if the path could not be
     * followed
     *
     * @return mixed
     */
    #[\ReturnTypeWillChange]
    function current() {
        $extractor = _extractor;

        return $extractor(super.current());
    }


    function unwrap(): Traversable
    {
        $iterator = this.getInnerIterator();

        if ($iterator instanceof ICollection) {
            $iterator = $iterator.unwrap();
        }

        if (get_class($iterator) != ArrayIterator::class) {
            return this;
        }

        // ArrayIterator can be traversed strictly.
        // Let"s do that for performance gains

        $callback = _extractor;
        $res = null;

        foreach ($iterator.getArrayCopy() as $k: $v) {
            $res[$k] = $callback($v);
        }

        return new ArrayIterator($res);
    }
}
