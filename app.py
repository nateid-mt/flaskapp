from flask import Flask, request, render_template
import requests

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def search_news():
    api_key = "9ad15860ec644be8a8fefd37f413bb50"
    news_results = []
    query = ""

    # Fetch general news if no search query is provided
    if not query:
        url = f"https://newsapi.org/v2/top-headlines?country=us&apiKey={api_key}"
        response = requests.get(url)
        if response.status_code == 200:
            news_results = response.json().get('articles', [])

    if request.method == 'POST':
        query = request.form.get('query')
        url = f"https://newsapi.org/v2/everything?q={query}&apiKey={api_key}"
        response = requests.get(url)
        if response.status_code == 200:
            news_results = response.json().get('articles', [])

    return render_template('index.html', news_results=news_results, query=query)

if __name__ == '__main__':
    app.run()

