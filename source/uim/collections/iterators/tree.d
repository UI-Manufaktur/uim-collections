/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.collections.iterators.tree;

/* use RecursiveIterator;
use RecursiveIteratorIterator; */

/**
 * A Recursive iterator used to flatten nested structures and also exposes
 * all Collection methods
 */
class TreeIterator : RecursiveIteratorIterator : ICollection {
    use CollectionTrait;

    /**
     * The iteration mode
     */
    protected int _mode;

    /**
     * Constructor
     *
     * @param \RecursiveIterator $items The iterator to flatten.
     * @param int $mode Iterator mode.
     * @param int $flags Iterator flags.
     */
    this(
        RecursiveIterator $items,
        int $mode = RecursiveIteratorIterator::SELF_FIRST,
        int $flags = 0
    ) {
        super(($items, $mode, $flags);
        _mode = $mode;
    }

    /**
     * Returns another iterator which will return the values ready to be displayed
     * to a user. It does so by extracting one property from each of the elements
     * and prefixing it with a spacer so that the relative position in the tree
     * can be visualized.
     *
     * Both $valuePath and $keyPath can be a string with a property name to extract
     * or a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * Alternatively, $valuePath and $keyPath can be callable functions. They will get
     * the current element as first parameter, the current iteration key as second
     * parameter, and the iterator instance as third argument.
     *
     * ### Example
     *
     * ```
     *  $printer = (new Collection($treeStructure)).listNested().printer("name");
     * ```
     *
     * Using a closure:
     *
     * ```
     *  $printer = (new Collection($treeStructure))
     *      .listNested()
     *      .printer(function ($item, $key, $iterator) {
     *          return $item.name;
     *      });
     * ```
     *
     * @param callable|string aValuePath The property to extract or a callable to return
     * the display value
     * @param callable|string|null $keyPath The property to use as iteration key or a
     * callable returning the key value.
     * @param string $spacer The string to use for prefixing the values according to
     * their depth in the tree
     * @return uim.collections.Iterator\TreePrinter
     */
    function printer($valuePath, $keyPath = null, $spacer = "__") {
        if (!$keyPath) {
            $counter = 0;
            $keyPath = function () use (&$counter) {
                return $counter++;
            };
        }

        return new TreePrinter(
            this.getInnerIterator(),
            $valuePath,
            $keyPath,
            $spacer,
            _mode
        );
    }
}
