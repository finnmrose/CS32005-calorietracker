from flask import Flask

data = {"":"""{
  "portion" : {
    "count" : {

    }
  },
  "id" : "CAEDBB70-3293-4771-9A23-509348304A55",
  "name" : "Banana",
  "timestamp" : 817042782.136986,
  "nutritional_info" : [
    2,
    1.3,
    0,
    105,
    1,
    27,
    3,
    0.39
  ]
}"""}



app = Flask(__name__)

@app.route("/<barcode>")
def fetch_info(barcode):
    print(barcode)
    return data[""]