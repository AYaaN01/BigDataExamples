@outputSchema("value:chararray")
def change_null_val(value):
    if value is None:
        return '0'
    return str(value)
 