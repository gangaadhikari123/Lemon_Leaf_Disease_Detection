from django.urls import path

from . import views

urlpatterns= [
    path('predict/',  views.predict_disease, name='predict'),
    path('health/',   views.HealthView.as_view(), name='health'),
    path('classes/', views.ClassView.as_view(), name='classes'),
    path('history/', views.HistoryView.as_view(), name='history'),
]  