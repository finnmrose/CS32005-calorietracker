from flask import Flask

data = {"03041741":"""{
  "id" : "79C7995A-D3F1-418A-ACEA-25FF10336568",
  "name" : "Tesco’s Hoisin Duck Wrap",
  "portion" : {
    "count" : {

    }
  },
  "timestamp" : 817312620.194154,
  "ingredients" : [

  ],
  "nutritional_info" : [
    3,
    10.7,
    0,
    379,
    1,
    52.4,
    2,
    17.1
  ]
}""",
"5000328028941":"""{
  "id" : "5E675EB4-7DFA-484E-90F2-0A2FD8C2361F",
  "timestamp" : 817312868.58686,
  "name" : "Sensations Thai Sweet Chilli",
  "portion" : {
    "weight" : {

    }
  },
  "nutritional_info" : [
    0,
    497,
    1,
    55,
    2,
    6.3,
    3,
    27
  ],
  "ingredients" : [

  ]
}""",
"90493430":"""{
  "id" : "833F8235-1736-4ACB-BFDC-AABEC6F924E5",
  "timestamp" : 817312909.080139,
  "ingredients" : [

  ],
  "name" : "Red Bull Cherry Edition",
  "portion" : {
    "volume" : {

    }
  },
  "nutritional_info" : [
    0,
    45,
    1,
    11
  ]
}""",
"5099802150117":"""{
  "nutritional_info" : [
    0,
    105,
    3,
    0.39,
    2,
    1.3,
    1,
    27
  ],
  "name" : "Banana",
  "id" : "1A7BD0AF-FDC6-48C1-9631-D1C2031BB55B",
  "timestamp" : 817230249.425937,
  "ingredients" : [

  ],
  "portion" : {
    "count" : {

    }
  }
}"""}



app = Flask(__name__)

@app.route("/<barcode>")
def fetch_info(barcode):
    print(barcode)
    return data[barcode]
