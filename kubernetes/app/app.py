from flask import Flask, request, jsonify, render_template
import requests
import random
import os

# OpenTelemetry 설정
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.trace import get_tracer_provider, set_tracer_provider
from opentelemetry import trace

# OpenTelemetry 설정 적용
tracer_provider = TracerProvider()
tracer_provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter(endpoint="http://otel-col:4318/v1/traces")))
set_tracer_provider(tracer_provider)
tracer = trace.get_tracer(__name__)

app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)  # Flask 자동 계측 활성화

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')

    with tracer.start_as_current_span("login-request") as span:
        span.set_attribute("username", username)

        if username == "admin" and password == "admin":
            return "<h2>Login</h2>", 200
        else:
            return "<h2>Wrong</h2>", 401

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

