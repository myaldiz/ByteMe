from django.shortcuts import render
from django.http import HttpResponse
import random

# Create your views here.
# def home(request):
#     #return render(request, "home.html", {}) #Response
#     subst_val = "sulo"
#     http_ = f"""selamunaleykum
#     adim {subst_val}
#     """
#     return HttpResponse(http_)

def generate(init=0, end=10000):
    return random.randint(0,10000)

def home(request):
    my_list = [generate() for _ in range(3)]
    dic = {"html_var": 'Test', 
    "num": generate(),
    "some_list": my_list
    }
    dic['bool_item'] = True
    return render(request, "base.html", dic)