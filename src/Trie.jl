module Tries

import Base.push!,
       Base.get,
       Base.haskey,
       Base.keys

export Trie,
       push!,
       get,
       haskey,
       keys,
       keys_with_prefix,
       subtrie

type Trie
    value::Int
    children::Dict{String,Trie}
    is_key::Bool
end

Trie() = Trie(0,(String=>Trie)[],false)

function Trie(words)
    t = Trie()
    for word in words
        push!(t, word)
    end
    return t
end

function push!(t::Trie, key::String)
    node = t
    val = 1
    for char in key
        if !haskey(node.children, string(char))
            node.children[string(char)] = Trie()
        end
        node = node.children[string(char)]
        val += 1
    end
    node.is_key = true
    node.value = val
    return t
end

function subtrie(t::Trie, prefix::String)
    node = t
    for char in prefix
        if !haskey(node.children, string(char))
            return nothing #should we error?
        else
            node = node.children[string(char)]
        end
    end
    return node
end
getindex(t::Trie,x) = subtrie(t,x)

function haskey(t::Trie, key::String)
    node = subtrie(t, key)
    return node != nothing && node.is_key
end

function get(t::Trie, key::String, default)
    node = subtrie(t, key)
    if node != nothing && node.is_key
        return node.value
    end
    return default
end

function keys(t::Trie, prefix::String="", found=String[])
    if t.is_key
        push!(found, prefix)
    end
    for (char,child) in t.children
        keys(child, string(prefix,char), found)
    end
    return found
end

function keys_with_prefix(t::Trie, prefix::String)
    st = subtrie(t, prefix)
    st != nothing ? keys(st,prefix) : []
end

end # module

# match Base semantics add/get/etc.
# compress/uncompress trie keys
# keys_with_prefix?
# better show for Trie
# tests
# docs
