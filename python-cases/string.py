def string_editor(str):
    count = {}
    for character in str:
        if character in count:
            count[character] += 1
        else:
            count[character] = 1
    max_char = max(count.items(), key=lambda x: x[1])

    new_string = list()
    for key, value in count.items():
        if value < max_char[1]:
            str = str.replace(key, '')

    print(str)


string_editor("BuBBrraakra")
