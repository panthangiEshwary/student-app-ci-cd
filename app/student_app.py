from flask import Flask, render_template, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

# MySQL connection from environment variables
db_config = {
    'host': os.environ.get("DB_HOST"),
    'user': os.environ.get("DB_USER"),
    'password': os.environ.get("DB_PASSWORD"),
    'database': os.environ.get("DB_NAME")
}

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/students.html")
def student_page():
    return render_template("students.html")

@app.route("/add_student", methods=["POST"])
def add_student():
    data = request.get_json()
    conn = mysql.connector.connect(**db_config)
    cur = conn.cursor()
    cur.execute("INSERT INTO students (name, email, course) VALUES (%s, %s, %s)",
                (data['name'], data['email'], data['course']))
    conn.commit()
    conn.close()
    return jsonify({"message": "Student added"}), 201

@app.route("/students", methods=["GET"])
def get_students():
    conn = mysql.connector.connect(**db_config)
    cur = conn.cursor()
    cur.execute("SELECT * FROM students")
    rows = cur.fetchall()
    conn.close()
    return jsonify([{"id": r[0], "name": r[1], "email": r[2], "course": r[3]} for r in rows])

@app.route("/health", methods=["GET"])
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run()
