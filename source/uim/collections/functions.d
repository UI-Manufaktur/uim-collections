/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.collections.functions;

@safe:
import uim.cake;

if (!function_exists("collection")) {
    /**
     * Returns a new {@link uim.collections.Collection} object wrapping the passed argument.
     *
     * @param iterable myItems The items from which the collection will be built.
     * @return uim.collections.Collection
     */
    ICollection collection(iterable myItems) {
        return new Collection(myItems);
    }

}