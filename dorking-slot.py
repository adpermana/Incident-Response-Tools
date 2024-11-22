import time
import sys
from googlesearch import search

def print_animated_text(text, delay=0.001):
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def search_gambling_pages(domain):
    # Define gambling-related keywords
    gambling_keywords = ['judi', 'casino', 'poker', 'slot', 'togel', 'gacor', 'Thailand', 'maxwin', 'deposit', 'betting', 'jackpot', 'asia', 'hoki', 'agen', 'cuan', 'dewa']

    # Search query format
    query = f"site:{domain} {' OR '.join(gambling_keywords)}"

    print("Searching", end="")
    for _ in range(3):  
        time.sleep(0.2)
        print(".", end="")
        sys.stdout.flush()
    print("\n")

    # Perform Google search
    urls = []
    try:
        # Iterasi dengan pencarian dan penundaan
        for result in search(query, num_results=100):  # Hanya ambil 100 hasil per iterasi
            urls.append(result)
            time.sleep(1)  
    except Exception as e:
        print(f"Terjadi kesalahan saat melakukan pencarian: {e}")

    # Filter and display results
    if urls:
        print(f"Found {len(urls)} potentially compromised URLs:")
        for url in urls:
            print(url)
        
        # Save results to a file
        filename = f"{domain}.txt"
        with open(filename, 'w', encoding='utf-8') as file:
            for url in urls:
                file.write(url + '\n')
        print(f"\nResults have been saved to {filename}")
    else:
        print(f"No gambling pages found for {domain}.")

if __name__ == "__main__":
    print_animated_text("============================================================")
    print_animated_text("=  __  __               _____   __       _____   ________  =")
    print_animated_text("= |  \/  |             /  ___| |  |     |  _  | |___  ___| =")
    print_animated_text("= | .  . |  ____      | |___   |  |     | | | |    |  |    =")
    print_animated_text("= | |\/| | |  __|      \___  \ |  |     | | | |    |  |    =")
    print_animated_text("= | |  | | | |    _    ___ | | |  |___  | |_| |    |  |    =")
    print_animated_text("= |_|  |_| |_|   |_|  |______/ |______| |_____|    |__|    =")
    print_animated_text("=                                                          =")
    print_animated_text("=                       Mr.Slot70                          =")
    print_animated_text("============================================================")
    time.sleep(0.5)  

    domain = input("Enter the domain (e.g., [subdomain].go.id): ")
    search_gambling_pages(domain)
