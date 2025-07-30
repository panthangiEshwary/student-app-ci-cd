from flask import Flask, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

db_config = {
    'host': os.environ.get("DB_HOST"),
    'user': os.environ.get("DB_USER"),
    'password': os.environ.get("DB_PASSWORD"),
    'database': os.environ.get("DB_NAME"),
    'port': int(os.environ.get("DB_PORT", 3306))
}

@app.route("/add_student", methods=["POST"])
def add_student():
    data = request.get_json()
    print("Received data:", data)
    if not data:
        return jsonify({"error": "No data received"}), 400

    try:
        conn = mysql.connector.connect(**db_config)
        cur = conn.cursor()
        cur.execute("INSERT INTO students (name, email, course) VALUES (%s, %s, %s)",
                    (data['name'], data['email'], data['course']))
        conn.commit()
        return jsonify({"message": "Student added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if conn.is_connected():
            cur.close()
            conn.close()

@app.route("/")
def home():
    return "Student App is running", 200
