from flask import Flask

data = {"":"""{
  "nutritional_info" : [
    0,
    105,
    1,
    27,
    3,
    0.39,
    2,
    1.3
  ],
  "ingredients" : [

  ],
  "portion" : {
    "count" : {

    }
  },
  "timestamp" : 817230249.425937,
  "name" : "Banana",
  "id" : "1A7BD0AF-FDC6-48C1-9631-D1C2031BB55B"
}"""}



app = Flask(__name__)

@app.route("/<barcode>")
def fetch_info(barcode):
    print(barcode)
    return data[""]
