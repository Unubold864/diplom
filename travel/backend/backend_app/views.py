from django.shortcuts import render, get_object_or_404
from rest_framework import status, generics
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import User, RecommendedPlace
from .serializers import UserSerializer, RecommendedPlaceSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny
from django.contrib.auth.hashers import check_password, make_password


class SignUpView(APIView):
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            # Hash the password before saving
            user = serializer.save()
            # Set the password properly using Django's password hashing
            user.set_password(request.data.get('password'))
            user.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        # Debug: Log the input email
        print(f"Login attempt with email: {email}")
        
        try:
            user = User.objects.get(email=email)
            print(f"User found: {user.name}")

            # Debug: Check the stored password hash
            print(f"Stored password hash: {user.password}")
            
            # Use Django's built-in check_password method
            if user.check_password(password):
                print("Password matched!")
                refresh = RefreshToken.for_user(user)
                return Response({
                    'access': str(refresh.access_token),
                    'refresh': str(refresh),
                    'user': {
                        'id': user.id,
                        'email': user.email,
                        'name': user.name
                    }
                }, status=status.HTTP_200_OK)
            else:
                print("Password mismatch!")
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            print("User not found!")
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        

class RecommendedPlaceListView(generics.ListCreateAPIView):
    queryset = RecommendedPlace.objects.all()
    serializer_class = RecommendedPlaceSerializer