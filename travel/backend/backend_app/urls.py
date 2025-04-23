from django.urls import path
from .views import SignUpView, LoginView, RecommendedPlaceListView, UserProfileView, NearbyPlacesView, PlaceListCreate, RestaurantList, HotelList, ParkingList
from rest_framework_simplejwt.views import (
    TokenRefreshView,
)
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('api/signup/', SignUpView.as_view(), name='signup'),
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/recommended_places/', RecommendedPlaceListView.as_view(), name='recommended-places-list'),
    path('api/profile/', UserProfileView.as_view(), name='user-profile'),
    path('api/nearby_places/', NearbyPlacesView.as_view(), name='nearby-places-list'),
    path('api/restaurants/', RestaurantList.as_view(), name='restaurant-list'),
    path('api/hotels/', HotelList.as_view(), name='hotel-list'),
    path('api/parkings/', ParkingList.as_view(), name='parking-list'),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)