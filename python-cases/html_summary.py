import pandas as pd
from collections import Counter

df = pd.read_csv("Cards.csv", sep=';')
maxx = df[df['Temperature'] == df['Temperature'].max()]
card_count = df['Card'].count()
dev_count = df['Device'].nunique()
max_temp = df['Temperature'].max()
card_on_dev = df.pivot_table(index=['Device'], aggfunc='size')
devs = df['Device'].drop_duplicates().values.tolist()
max_temp_on_dev = df.groupby('Device').max()
high_temp_count = df[df['Temperature'].gt(70)].groupby("Device").count()
high_temp_count_list = []
for dev in devs:
    try:
        count = high_temp_count['Card'][dev]
    except KeyError:
        count = 0
    high_temp_count_list.append(count)
avg_temp = df.groupby('Device').mean()

summary = pd.DataFrame({'Total Devices': [dev_count], 'Total Cards': [card_count], 'Max Card Temperature': [max_temp],
                        'Hottest Card / Device': [" / ".join([maxx._get_value(0, 1, takeable=True),
                                                              maxx._get_value(0, 0, takeable=True)])]}).transpose()

devices = pd.DataFrame({'Devices': devs, 'Card Number': card_on_dev, 'High Temp Cards': high_temp_count_list,
                        'Max Temperature': max_temp_on_dev['Temperature'], 'Avg. Temperature': avg_temp['Temperature']})

html = summary.to_html(header=False)
html1 = devices.to_html(index=False)

text_file = open("index.html", "w")
message = """<h1>Summary</h1>"""
message1 = """<h3>Devices</h3>"""
message2 = """(High Temperature >= 70)"""
text_file.write(message)
text_file.write(html)
text_file.write(message1)
text_file.write(html1)
text_file.write(message2)
text_file.close()