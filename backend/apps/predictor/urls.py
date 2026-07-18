from django.urls import path
from .views import predict_image,health,classes,history,predict_ui

urlpatterns = [
    
    path('predict-ui/', predict_ui), 

    path('predict/', predict_image),
    path("health/", health),
    path("classes/", classes),
    path("history/", history),

]