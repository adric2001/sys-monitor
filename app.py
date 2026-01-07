import psutil
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def health_check():
    return jsonify({
        "status": "running",
        "system_stats": {
            "cpu_usage": f"{psutil.cpu_percent()}%",
            "memory_usage": f"{psutil.virtual_memory().percent}%",
            "disk_usage": f"{psutil.disk_usage('/').percent}%"
        },
        "message": "System is healthy and containerized."
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)