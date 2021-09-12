from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "<h1 style='color:red'>Hello From Python from docker!</h1>"


@app.route("/python")
def api():
    return "<h1 style='color:red'>Hello From Python api!</h1>"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
