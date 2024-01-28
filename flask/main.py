from flask import Flask, request, jsonify, make_response
from openai import OpenAI
import os

app = Flask(__name__)

# Set your OpenAI API key as an environment variable
os.environ["OPENAI_API_KEY"] = "API_KEY_HERE"



@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/ask', methods=['POST'])
def ask():
    try:
        # Parse the incoming JSON to extract the user's message
        
        data = request.get_json()
        print(data)
        user_message = data['message']
        print(user_message)

        client = OpenAI()
        print('client')
        print(client)

        # Make a request to the OpenAI API with the user's message
        completion = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "Make a recipie tha combines the following foods."},
                {"role": "user", "content": user_message}
            ]
        )

        for choice in completion.choices:
            response_message = choice.message.content
        print(response_message)

        # Create a response object and set custom headers
        response = make_response(jsonify({"response": response_message}))
        # response.headers['Content-Type'] = 'application/json'  

        return response
    #     # Extract the response message and return it as JSON
    #     # response_message = completion.choices[0].message
    #     # print(response_message)
    #     # return jsonify({"response": response_message})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=8080,debug=True)
