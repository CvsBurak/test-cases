# delete minimum nubmers from array to leave only elements of equal value
def equalizeArray(arr):
    nums = {x: 0 for x in arr}
    for num in arr:
        nums[num] += 1

    delNum = max(nums, key=nums.get)
    arr = [i for i in arr if i != delNum]

    return len(arr)

print(equalizeArray([3,5,4,6,3,3,3,4]))
