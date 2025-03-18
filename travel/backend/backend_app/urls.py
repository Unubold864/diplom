from django.urls import path
from .views import SignUpView, LoginView, RecommendedPlaceListView
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('api/signup/', SignUpView.as_view(), name='signup'),
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/recommended_places/', RecommendedPlaceListView.as_view(), name='recommended-places-list'),
    
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)