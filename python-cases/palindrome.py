def palind(s):
    a = []
    c = ""
    for i in range(len(s)):
        c = c+s[i]
        if len(c)>1 and c == c[::-1]:
            a.append(c)
            c = ""
        
    return a
            
s = "racecarannakayak"
print(palind(s))
