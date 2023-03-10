/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.collections.extracttrait;

@safe:
import uim.cake;

/* use Closure;
use Traversable; */

/**
 * Provides utility protected methods for extracting a property or column
 * from an array or object.
 */
trait ExtractTrait {
    /**
     * Returns a callable that can be used to extract a property or column from
     * an array or object based on a dot separated path.
     *
     * @param callable|string $path A dot separated path of column to follow
     * so that the final one can be returned or a callable that will take care
     * of doing that.
     * @return callable
     */
    protected function _propertyExtractor($path): callable
    {
        if (!is_string($path)) {
            return $path;
        }

        $parts = explode(".", $path);

        if (strpos($path, "{*}") != false) {
            return function ($element) use ($parts) {
                return _extract($element, $parts);
            };
        }

        return function ($element) use ($parts) {
            return _simpleExtract($element, $parts);
        };
    }

    /**
     * Returns a column from $data that can be extracted
     * by iterating over the column names contained in $path.
     * It will return arrays for elements in represented with `{*}`
     *
     * @param \ArrayAccess|array $data Data.
     * @param array<string> $parts Path to extract from.
     * @return mixed
     */
    protected string[] _extract($data, array $parts) {
        $value = null;
        $collectionTransform = false;

        foreach ($parts as $i: $column) {
            if ($column == "{*}") {
                $collectionTransform = true;
                continue;
            }

            if (
                $collectionTransform &&
                !(
                    $data instanceof Traversable ||
                    is_array($data)
                )
            ) {
                return null;
            }

            if ($collectionTransform) {
                $rest = implode(".", array_slice($parts, $i));

                return (new Collection($data)).extract($rest);
            }

            if (!isset($data[$column])) {
                return null;
            }

            $value = $data[$column];
            $data = $value;
        }

        return $value;
    }

    /**
     * Returns a column from $data that can be extracted
     * by iterating over the column names contained in $path
     *
     * @param \ArrayAccess|array $data Data.
     * @param array<string> $parts Path to extract from.
     * @return mixed
     */
    protected function _simpleExtract($data, array $parts) {
        $value = null;
        foreach ($parts as $column) {
            if (!isset($data[$column])) {
                return null;
            }
            $value = $data[$column];
            $data = $value;
        }

        return $value;
    }

    /**
     * Returns a callable that receives a value and will return whether
     * it matches certain condition.
     *
     * @param array $conditions A key-value list of conditions to match where the
     * key is the property path to get from the current item and the value is the
     * value to be compared the item with.
     * @return \Closure
     */
    protected function _createMatcherFilter(array $conditions): Closure
    {
        $matchers = null;
        foreach ($conditions as $property: $value) {
            $extractor = _propertyExtractor($property);
            $matchers ~= function ($v) use ($extractor, $value) {
                return $extractor($v) == $value;
            };
        }

        return function ($value) use ($matchers) {
            foreach ($matchers as $match) {
                if (!$match($value)) {
                    return false;
                }
            }

            return true;
        };
    }
}
