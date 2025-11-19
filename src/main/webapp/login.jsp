<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&family=Merriweather:ital,wght@0,700;1,400&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F7F5F3; color: #37352F; }
        h1, h2, h3 { font-family: 'Merriweather', serif; }
    </style>
</head>
<body class="h-screen flex items-center justify-center">

    <div class="w-full max-w-md p-8">
        <div class="text-center mb-10">
            <h2 class="text-3xl font-bold text-[#37352F]">Welcome back</h2>
        </div>

        <div class="bg-white shadow-sm border border-gray-200 rounded-xl p-8">
            
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div class="mb-4 p-3 bg-red-50 text-red-600 text-sm rounded border border-red-100 flex items-center gap-2">
                    Invalid credentials
                </div>
            <% } else if ("created".equals(request.getParameter("message"))) { %>
                <div class="mb-4 p-3 bg-green-50 text-green-700 text-sm rounded border border-green-100">
                    Account created. Please log in.
                </div>
            <% } %>

            <form action="auth" method="post" class="space-y-5">
                <input type="hidden" name="action" value="login">
                
                <div>
                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">Username</label>
                    <input type="text" name="username" required 
                           class="w-full px-3 py-2 bg-[#F7F6F3] border border-gray-200 rounded focus:outline-none focus:ring-2 focus:ring-gray-400 focus:bg-white transition text-sm">
                </div>
                
                <div>
                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">Password</label>
                    <input type="password" name="password" required 
                           class="w-full px-3 py-2 bg-[#F7F6F3] border border-gray-200 rounded focus:outline-none focus:ring-2 focus:ring-gray-400 focus:bg-white transition text-sm">
                </div>
                
                <button type="submit" class="w-full bg-[#37352F] text-white font-medium py-2.5 rounded hover:bg-black transition shadow-sm text-sm">
                    Continue
                </button>
            </form>
        </div>

        <p class="text-center mt-8 text-sm text-gray-500">
            New here? <a href="register.jsp" class="text-[#37352F] font-semibold hover:underline">Create an account</a>
        </p>
    </div>

</body>
</html>