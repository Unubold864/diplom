from django.urls import path
from . import views

urlpatterns = [
    path('', views.MyModelViewSet.as_view({'get': 'list'}), name='my-model'),
]
