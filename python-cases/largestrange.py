# gets the largest range of numbers contained in the array
def largestRange(arr):
  nums = {x:0 for x in arr}  #creating hashmap for elements in arr
  left = right = 0
  
  for num in arr:
    if nums[num] == 0:
      left_count = num - 1
      right_count = num + 1
      
      
      while left_count in nums:
        nums[left_count] = 1
        left_count -= 1
      left_count += 1
      
      while right_count in nums:
        nums[right_count] = 1
        right_count += 1
      right_count -= 1
      
      if (right - left) <= (right_count - left_count):
        right = right_count
        left = left_count
       
      return [left, right]
      
