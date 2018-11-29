from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.

def Approve(request):
    dic = {}
    #return render(request, "approve.html", dic)
    return HttpResponse("Hello World!")