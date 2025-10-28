from flask import Flask, jsonify
from main import add, sub

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        "message": "Hello from Kubernetes!",
        "app": "Python Calculator API",
        "status": "running"
    })

@app.route('/add/<int:a>/<int:b>')
def api_add(a, b):
    result = add(a, b)
    return jsonify({
        "operation": "addition",
        "a": a,
        "b": b,
        "result": result
    })

@app.route('/sub/<int:a>/<int:b>')
def api_sub(a, b):
    result = sub(a, b)
    return jsonify({
        "operation": "subtraction",
        "a": a,
        "b": b,
        "result": result
    })

@app.route('/health')
def health_check():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)