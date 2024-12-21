from django.urls import path
from App.views import *
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('register/', register_view, name='register'),
    path('login/', login_view, name='login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('logout/', logout_view, name='logout'),
    path('protected/', protected_view, name='protected'),
    path("customer/", customer_list, name='customer'),
    path("add_customer/", add_customer, name='add_customer'),
    path("branch/", branch_list, name='branch'),
    path("add_branch/", add_branch, name='add_branch'),
    path("role/", role_list, name='role'),
    path("add_role/", add_role, name='add_role'),
    path("worker/", worker_list, name='worker'),
    path("add_worker/", add_worker, name='add_worker'),
    path("service/", service_list, name='service'),
    path('add_service/', add_service, name='add_service'),
    path('edit_service/<int:service_id>/', edit_service, name='edit_service'),
    path('delete_service/<int:service_id>/', delete_service, name='delete_service'),
]
