"""from django.urls import path
from .views import index

urlpatterns = [
    path("", index, name="index"),
]"""

from django.urls import path
from .views import index, api_upload

urlpatterns = [
    path("", index, name="index"),
    path("api/upload/", api_upload, name="api_upload"),
]