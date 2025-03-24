from django.contrib import admin
from .models import Customer, Branch, Role, Worker, Service, CalendarEvent, ServiceCategory

# Registering models with the admin site
admin.site.register(Customer)
admin.site.register(Branch)
admin.site.register(Role)
admin.site.register(Worker)
admin.site.register(ServiceCategory)
admin.site.register(Service)
admin.site.register(CalendarEvent)

