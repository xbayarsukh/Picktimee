from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db import connection
from .serializers import CalendarEventSerializer
from .models import CalendarEvent
import json
from django.core.exceptions import ObjectDoesNotExist

# Generate JWT tokens
def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

@api_view(['POST'])
def register_customer(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists'}, status=400)

    user = User.objects.create_user(username=username, email=email, password=password)
    user.save()
    return Response({'message': 'Customer registered successfully'})

@api_view(['POST'])
def login_customer(request):
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(username=username, password=password)
    if user is not None:
        tokens = get_tokens_for_user(user)
        return Response({'message': 'Login successful', 'tokens': tokens})
    else:
        return Response({'error': 'Invalid credentials'}, status=400)


# Registration View
@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    username = request.data.get('username')
    password = request.data.get('password')
    email = request.data.get('email')
    first_name = request.data.get('first_name')
    last_name = request.data.get('last_name')

    # Basic validation (you can expand this as needed)
    if not username or not password or not email:
        return Response({"error": "Username, password, and email are required."}, status=status.HTTP_400_BAD_REQUEST)

    # Check if the username already exists
    if User.objects.filter(username=username).exists():
        return Response({"error": "Username is already taken."}, status=status.HTTP_400_BAD_REQUEST)

    # Create the user
    user = User.objects.create_user(
        username=username,
        password=password,
        email=email,
        first_name=first_name,
        last_name=last_name
    )
    user.save()
    return Response({"message": "User created successfully."}, status=status.HTTP_201_CREATED)


##################################################################################################################################################


# Login View
@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    username = request.data.get('username')
    password = request.data.get('password')
    user = authenticate(username=username, password=password)

    if user:
        refresh = RefreshToken.for_user(user)
        return Response({
            'access': str(refresh.access_token),
            'refresh': str(refresh)
        })
    return Response({"error": "Invalid username or password."}, status=status.HTTP_401_UNAUTHORIZED)

# Logout View to blacklist tokens (optional)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    try:
        refresh_token = request.data.get("refresh")
        token = RefreshToken(refresh_token)
        token.blacklist()
        return Response(status=status.HTTP_205_RESET_CONTENT)
    except Exception as e:
        return Response({"error": "Invalid refresh token provided."}, status=status.HTTP_400_BAD_REQUEST)

# Protected View (Example)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def protected_view(request):
    return Response({"message": "This is a protected route, accessible only with a valid token."})




###########################################################################################################################################




def customer_list(request):
    if request.method == 'GET':
        try:
            page = int(request.GET.get('page', 1))
            limit = 10  # Number of customers per page
            offset = (page - 1) * limit

            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT *
                    FROM t_customer
                    LIMIT %s OFFSET %s;
                """, [limit, offset])
                rows = cursor.fetchall()

            # Map the rows to a dictionary structure matching the React table's requirements
            customers = [
                {
                    "customer_id": row[0],
                    "cname": row[1],
                    "cemail": row[2],
                    "cphone": row[3],
                }
                for row in rows
            ]

            return JsonResponse(customers, safe=False, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)

@csrf_exempt
def add_customer(request):
    if request.method == "POST":
        try:
            # Parse the request body
            data = json.loads(request.body)
            cname = data.get("cname")
            cemail = data.get("cemail")
            cphone = data.get("cphone")

            # Generate a new customer_id (assuming auto-increment is not used)
            with connection.cursor() as cursor:
                cursor.execute("SELECT COALESCE(MAX(customer_id), 0) + 1 FROM t_customer")
                customer_id = cursor.fetchone()[0]

            # Insert the new customer record
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO t_customer (customer_id, cname, cemail, cphone)
                    VALUES (%s, %s, %s, %s)
                    """,
                    [customer_id, cname, cemail, cphone]
                )

            return JsonResponse({"message": "Customer added successfully", "customer_id": customer_id}, status=201)
        
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request method"}, status=405)


###########################################################################################################################################



def branch_list(request):
    if request.method == 'GET':
        try:
            page = int(request.GET.get('page', 1))
            limit = 10  # Number of branches per page
            offset = (page - 1) * limit

            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT *
                    FROM t_branch
                    LIMIT %s OFFSET %s;
                """, [limit, offset])
                rows = cursor.fetchall()

            # Map the rows to a dictionary structure matching the React table's requirements
            branches = [
                {
                    "branch_id": row[0],
                    "bname": row[1],
                    "blocation": row[2],
                }
                for row in rows
            ]

            return JsonResponse(branches, safe=False, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)


@csrf_exempt
def add_branch(request):
    if request.method == "POST":
        try:
            # Parse the request body
            data = json.loads(request.body)
            bname = data.get("bname")
            blocation = data.get("blocation")

            # Generate a new branch_id (handling case when no rows exist)
            with connection.cursor() as cursor:
                cursor.execute('SELECT MAX(branch_id) FROM t_branch')  # Use the correct column name
                result = cursor.fetchone()
                
                # If no rows exist, start with 1; otherwise, increment the max branch_id
                branch_id = result[0] + 1 if result[0] is not None else 1

            # Insert the new branch record
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO t_branch (branch_id, bname, blocation)
                    VALUES (%s, %s, %s)
                    """,
                    [branch_id, bname, blocation]
                )

            return JsonResponse({"message": "Branch added successfully", "branch_id": branch_id}, status=201)
        
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request method"}, status=405)



###########################################################################################################################################



def role_list(request):
    if request.method == 'GET':
        try:
            page = int(request.GET.get('page', 1))
            limit = 10  # Number of roles per page
            offset = (page - 1) * limit

            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT role_id, role_name
                    FROM t_role
                    LIMIT %s OFFSET %s;
                """, [limit, offset])
                rows = cursor.fetchall()

            # Map the rows to a dictionary structure matching the React table's requirements
            roles = [
                {
                    "role_id": row[0],
                    "role_name": row[1],
                }
                for row in rows
            ]

            return JsonResponse(roles, safe=False, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)



@csrf_exempt
def add_role(request):
    if request.method == "POST":
        try:
            # Parse the request body
            data = json.loads(request.body)
            role_name = data.get("role_name")

            # Generate a new role_id (handling case when no rows exist)
            with connection.cursor() as cursor:
                cursor.execute('SELECT MAX(role_id) FROM t_role')  # Use the correct column name
                result = cursor.fetchone()
                
                # If no rows exist, start with 1; otherwise, increment the max role_id
                role_id = result[0] + 1 if result[0] is not None else 1

            # Insert the new role record
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO t_role (role_id, role_name)
                    VALUES (%s, %s)
                    """,
                    [role_id, role_name]
                )

            return JsonResponse({"message": "Role added successfully", "role_id": role_id}, status=201)
        
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request method"}, status=405)



###########################################################################################################################################




def worker_list(request):
    if request.method == 'GET':
        try:
            page = int(request.GET.get('page', 1))
            limit = 10  # Number of workers per page
            offset = (page - 1) * limit

            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT 
                        w.worker_id, 
                        w.wfirst, 
                        w.wname, 
                        w.wphone, 
                        r.role_name, 
                        b.bname
                    FROM 
                        t_worker w
                    JOIN 
                        t_role r ON w.role_id = r.role_id
                    JOIN 
                        t_branch b ON w.branch_id = b.branch_id
                    LIMIT %s OFFSET %s;
                """, [limit, offset])
                rows = cursor.fetchall()

            # Move the print statement after defining the workers list
            workers = [
                {
                    "worker_id": row[0],
                    "wfirst": row[1],
                    "wname": row[2],
                    "wphone": row[3],
                    "role_name": row[4],
                    "bname": row[5],
                }
                for row in rows
            ]
            print(workers)

            return JsonResponse(workers, safe=False, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)


@csrf_exempt
def add_worker(request):
    if request.method == "POST":
        try:
            # Parse the request body
            data = json.loads(request.body)
            wfirst = data.get("wfirst")
            wname = data.get("wname")
            wphone = data.get("wphone")
            role_id = data.get("role_id")
            branch_id = data.get("branch_id")

            # Validate inputs
            if not all([wfirst, wname, wphone, role_id]):
                return JsonResponse({"error": "Missing required fields"}, status=400)

            # Convert branch_id to an integer or handle missing/empty branch_id
            branch_id = int(branch_id) if branch_id else None

            # Insert the new worker record
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO t_worker (wfirst, wname, wphone, role_id, branch_id)
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING worker_id
                    """,
                    [wfirst, wname, wphone, role_id, branch_id]
                )
                worker_id = cursor.fetchone()[0]

            return JsonResponse({"message": "Worker added successfully", "worker_id": worker_id}, status=201)
        
        except ValueError as e:
            return JsonResponse({"error": "Invalid input: branch_id must be an integer"}, status=400)
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request method"}, status=405)



###########################################################################################################################################



def service_list(request):
    if request.method == 'GET':
        try:
            page = int(request.GET.get('page', 1))
            limit = 10  # Number of services per page
            offset = (page - 1) * limit

            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT *
                    FROM t_service
                    LIMIT %s OFFSET %s;
                """, [limit, offset])
                rows = cursor.fetchall()

            # Map the rows to a dictionary structure matching the React table's requirements
            services = [
                {
                    "service_id": row[0],
                    "sname": row[1],
                    "sprice": (row[2]),
                    "sduration": row[3],
                }
                for row in rows
            ]

            return JsonResponse(services, safe=False, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)



@csrf_exempt
def add_service(request):
    if request.method == 'POST':
        try:
            # Parse the request body
            data = json.loads(request.body)
            sname = data.get('sname')
            sprice = data.get('sprice')
            sduration = data.get('sduration')

            # Debugging print (optional: log these values for debugging in production)
            print("Received data:", data)

            # Validate input
            if not sname or sprice is None or sduration is None:
                return JsonResponse({'error': 'Missing required fields'}, status=400)

            # Try to cast sprice to an integer
            try:
                sprice = int(sprice)  # Explicitly cast to integer
            except ValueError:
                return JsonResponse({'error': 'Invalid value for sprice. It should be an integer.'}, status=400)

            # Validate the types again after the cast
            if not isinstance(sduration, str):
                return JsonResponse({'error': f"Invalid type for 'sduration'. Expected str, got {type(sduration).__name__}"}, status=400)

            # Additional validation
            if sprice < 0:
                return JsonResponse({'error': 'Price must be a positive value'}, status=400)

            if len(sduration.strip()) == 0:
                return JsonResponse({'error': 'Duration cannot be empty'}, status=400)

            # Insert into the database
            with connection.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO t_service (sname, sprice, sduration)
                    VALUES (%s, %s, %s)
                    RETURNING service_id;
                """, [sname, sprice, sduration])
                service_id = cursor.fetchone()

            if service_id:
                return JsonResponse({'message': 'Service added successfully', 'service_id': service_id[0]}, status=201)
            else:
                return JsonResponse({'error': 'Service insertion failed'}, status=500)

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    


@csrf_exempt
def edit_service(request, service_id):
    if request.method == 'PUT':  # Use PUT method for updating
        try:
            data = json.loads(request.body)
            sname = data.get('sname')
            sprice = data.get('sprice')
            sduration = data.get('sduration')

            if not sname or sprice is None or sduration is None:
                return JsonResponse({'error': 'Missing required fields'}, status=400)

            try:
                sprice = int(sprice)
            except ValueError:
                return JsonResponse({'error': 'Invalid value for sprice. It should be an integer.'}, status=400)

            if not isinstance(sduration, str):
                return JsonResponse({'error': f"Invalid type for 'sduration'. Expected str, got {type(sduration).__name__}"}, status=400)

            if sprice < 0:
                return JsonResponse({'error': 'Price must be a positive value'}, status=400)

            if len(sduration.strip()) == 0:
                return JsonResponse({'error': 'Duration cannot be empty'}, status=400)

            with connection.cursor() as cursor:
                cursor.execute("""
                    UPDATE t_service
                    SET sname = %s, sprice = %s, sduration = %s
                    WHERE service_id = %s;
                """, [sname, sprice, sduration, service_id])

                if cursor.rowcount > 0:
                    return JsonResponse({'message': 'Service updated successfully'}, status=200)
                else:
                    return JsonResponse({'error': 'Service not found or no changes made'}, status=404)

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)



@csrf_exempt
def delete_service(request, service_id):
    if request.method == 'DELETE':
        try:
            with connection.cursor() as cursor:
                cursor.execute("""
                    DELETE FROM t_service
                    WHERE service_id = %s;
                """, [service_id])

                if cursor.rowcount > 0:
                    return JsonResponse({'message': 'Service deleted successfully'}, status=200)
                else:
                    return JsonResponse({'error': 'Service not found'}, status=404)

        except Exception as e:
            # Log the error (optional: configure logging in settings.py)
            return JsonResponse({'error': 'An error occurred: {}'.format(str(e))}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)  # 405 for invalid method

# Create Event
@api_view(['POST'])
def create_event(request):
    if request.method == 'POST':
        serializer = CalendarEventSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  
            return Response(serializer.data, status=status.HTTP_201_CREATED)  
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)  

# List Events
@api_view(['GET'])
def list_events(request):
    # Retrieve query parameters
    worker_id = request.query_params.get('worker') 
    branch = request.query_params.get('branch')  

    # Filter events
    events = CalendarEvent.objects.all()
    if worker_id:
        events = events.filter(worker_id=worker_id)
    if branch:
        events = events.filter(branch=branch)

    # Serialize and return response
    serializer = CalendarEventSerializer(events, many=True)
    return Response(serializer.data)


# Get Event by ID
@api_view(['GET'])
def get_event(request, event_id):
    try:
        event = CalendarEvent.objects.get(event_id=event_id)  
    except CalendarEvent.DoesNotExist:
        return Response({"detail": "Event not found."}, status=status.HTTP_404_NOT_FOUND)  

    serializer = CalendarEventSerializer(event)  
    return Response(serializer.data)  

# Update Event
@api_view(['PUT'])
def update_event(request, event_id):
    try:
        event = CalendarEvent.objects.get(event_id=event_id)  
    except CalendarEvent.DoesNotExist:
        return Response({"detail": "Event not found."}, status=status.HTTP_404_NOT_FOUND)  

    serializer = CalendarEventSerializer(event, data=request.data) 
    if serializer.is_valid():
        serializer.save() 
        return Response({"status": "success", "data": serializer.data}) 
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def delete_event(request, event_id):
    try:
        event = CalendarEvent.objects.get(event_id=event_id) 
    except CalendarEvent.DoesNotExist:
        return Response({"detail": "Event not found."}, status=status.HTTP_404_NOT_FOUND) 

    event.delete() 
    return Response({"detail": "Event deleted successfully."}, status=status.HTTP_204_NO_CONTENT) 


    ###########################################################################################################################################
