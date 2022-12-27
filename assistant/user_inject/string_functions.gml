//=============================================
#define string_split(str, delimiter)
//because Dan said no
{
    var num_dels = string_count(delimiter, str);
    var split_array = array_create(num_dels + 1);

    for (var i = 0; i < num_dels; i++)
    {
        var p = string_pos(delimiter, str)
        if (p > 0)
        {
            split_array[i] = string_copy(str, 1, p - 1);
            str = string_delete(str, 1, p);
        }
        else split_array[i] = str;
    }

    return split_array;
}