from django.db import models
from django.utils import timezone

# Customer Model
class Customer(models.Model):
    customer_id = models.AutoField(primary_key=True)
    cname = models.CharField(max_length=255, verbose_name="Customer Name")
    cemail = models.EmailField(unique=True, verbose_name="Customer Email")
    cphone = models.CharField(max_length=15, verbose_name="Customer Phone")

    class Meta:
        db_table = "t_customer"
        verbose_name = "Customer"
        verbose_name_plural = "Customers"

    def __str__(self):
        return self.cname


# Branch Model
class Branch(models.Model):
    branch_id = models.AutoField(primary_key=True)
    bname = models.CharField(max_length=255, verbose_name="Branch Name")
    blocation = models.CharField(max_length=255, verbose_name="Branch Location")

    class Meta:
        db_table = "t_branch"
        verbose_name = "Branch"
        verbose_name_plural = "Branches"

    def __str__(self):
        return self.bname


# Role Model
class Role(models.Model):
    role_id = models.AutoField(primary_key=True)
    role_name = models.CharField(max_length=255, unique=True, verbose_name="Role Name")

    class Meta:
        db_table = "t_role"
        verbose_name = "Role"
        verbose_name_plural = "Roles"

    def __str__(self):
        return self.role_name


# Worker Model
class Worker(models.Model):
    worker_id = models.AutoField(primary_key=True)
    wfirst = models.CharField(max_length=255, verbose_name="Worker First Name")
    wname = models.CharField(max_length=255, verbose_name="Worker Last Name")
    wphone = models.CharField(max_length=15, unique=True, verbose_name="Worker Phone")
    role = models.ForeignKey(Role, on_delete=models.CASCADE, related_name="workers", verbose_name="Role")
    branch = models.ForeignKey(Branch, null=True, blank=True, on_delete=models.SET_NULL, related_name="workers", verbose_name="Branch")

    class Meta:
        db_table = "t_worker"
        verbose_name = "Worker"
        verbose_name_plural = "Workers"

    def __str__(self):
        return f"{self.wfirst} {self.wname}"

# Service Model
class Service(models.Model):
    service_id = models.AutoField(primary_key=True)
    sname = models.CharField(max_length=255, verbose_name="Service Name")
    sprice = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Service Price")
    sduration = models.CharField(max_length=255, unique=True, verbose_name="Duration")
    simage = models.ImageField(upload_to='images/', null=True, blank=True, verbose_name="Service Image")
    scomment = models.TextField(null=True, blank=True, verbose_name="Comment")

    class Meta:
        db_table = "t_service"
        verbose_name = "Service"
        verbose_name_plural = "Services"
        ordering = ['sname']

    def __str__(self):
        return self.sname
    
class CalendarEvent(models.Model):
    event_id = models.AutoField(primary_key=True)
    description = models.TextField(verbose_name="Event Description", blank=True, null=True)
    start_time = models.DateTimeField(verbose_name="Start Time", default=timezone.now)
    end_time = models.DateTimeField(verbose_name="End Time", default=timezone.now)
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name="events", verbose_name="Service")
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name="events", verbose_name="Customer")
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name="events", verbose_name="Worker", null=True, blank=True)
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE, related_name="events", verbose_name="Branch")
    
    class Meta:
        db_table = "t_calendar_event"
        verbose_name = "Calendar Event"
        verbose_name_plural = "Calendar Events"
        ordering = ['start_time']

    def __str__(self):
        return self.description