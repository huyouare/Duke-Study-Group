import json

with open("subjects.json") as json_file:
  json_data = json.load(json_file)
  print(json_data["values"])
# json.dumps()
