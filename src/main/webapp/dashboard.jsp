<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Workspace</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,400;500;600&family=Lora:ital,wght@0,600;1,400&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-beige: #F5F2EB;
            --text-dark: #2D332F;
            --accent-sage: #4A5D50;
        }
        body { font-family: 'DM Sans', sans-serif; color: var(--text-dark); background-color: var(--bg-beige); }
        h1, h2, .serif { font-family: 'Lora', serif; }
        
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
        .task-text { transition: color 0.2s ease, text-decoration 0.2s ease; }
        .check-btn { transition: background-color 0.2s ease, border-color 0.2s ease; }
        .hidden { display: none; }
    </style>
</head>
<body class="flex h-screen overflow-hidden">

    <aside class="w-64 flex-shrink-0 flex flex-col pt-6 pb-4 px-3 border-r border-[#E6E2D6] bg-[#F5F2EB]">
        
        <div class="flex items-center gap-3 px-3 mb-8 group">
            <div class="w-8 h-8 bg-[#D8D3C5] rounded-full flex items-center justify-center text-[#4A5D50] font-bold text-sm">
                ${username.substring(0,1).toUpperCase()}
            </div>
            <div class="flex-grow min-w-0">
                <div class="text-sm font-semibold truncate text-[#4A5D50]">${username}</div>
                <div class="text-xs text-gray-500">Personal Plan</div>
            </div>
            <a href="auth?action=logout" class="text-gray-400 opacity-0 group-hover:opacity-100 hover:text-red-500 transition">
                <i class="ph ph-sign-out text-lg"></i>
            </a>
        </div>

        <div class="flex-1 overflow-y-auto no-scrollbar space-y-1">
            <a href="tasks" class="flex items-center gap-3 px-3 py-2 text-sm rounded-lg transition ${currentCat == null ? 'bg-[#E0E6E2] text-[#2D332F] font-semibold' : 'text-gray-600 hover:bg-[#EBE8DF]'}">
                <i class="ph ph-inbox text-lg"></i>
                <span>Inbox</span>
            </a>

            <div class="mt-8 px-3 mb-2 text-[11px] font-bold tracking-wider text-gray-400 uppercase">Projects</div>

            <c:forEach var="cat" items="${categoryList}">
                <div class="group flex items-center justify-between px-3 py-1.5 rounded-lg transition cursor-pointer ${currentCat == cat.id ? 'bg-[#E0E6E2]' : 'hover:bg-[#EBE8DF]'}">
                    <a href="tasks?category=${cat.id}" class="flex-grow flex items-center gap-3 text-sm truncate">
                        <span class="w-2 h-2 rounded-full ${currentCat == cat.id ? 'bg-[#4A5D50]' : 'bg-[#D8D3C5]'}"></span>
                        <span class="${currentCat == cat.id ? 'font-semibold text-[#2D332F]' : 'text-gray-600'}">${cat.name}</span>
                    </a>
                    <form action="tasks" method="post" onsubmit="return confirm('Delete list: ${cat.name}?');">
                        <input type="hidden" name="action" value="deleteCategory">
                        <input type="hidden" name="id" value="${cat.id}">
                        <button type="submit" class="w-5 h-5 flex items-center justify-center rounded hover:bg-[#D1CCC0] text-gray-400 hover:text-red-500 opacity-0 group-hover:opacity-100 transition">
                            <i class="ph ph-x text-sm"></i>
                        </button>
                    </form>
                </div>
            </c:forEach>

            <button onclick="openModal()" class="w-full mt-2 flex items-center gap-2 px-3 py-2 text-sm text-gray-500 hover:text-[#4A5D50] hover:bg-[#EBE8DF] rounded-lg transition text-left">
                <i class="ph ph-plus"></i>
                <span>Add Page</span>
            </button>
        </div>
    </aside>

    <main class="flex-1 flex flex-col h-screen overflow-hidden bg-[#FFFEFC] relative shadow-2xl shadow-[#E6E2D6]/50 rounded-l-3xl my-2 mr-2 border border-[#E6E2D6]">
        
        <div class="h-40 w-full bg-gradient-to-r from-[#ECE9E0] to-[#F5F2EB] relative overflow-hidden">
            <div class="absolute -top-10 -right-10 w-64 h-64 bg-[#4A5D50]/5 rounded-full blur-3xl"></div>
            <div class="absolute bottom-0 left-0 w-full h-24 bg-gradient-to-t from-[#FFFEFC] to-transparent"></div>
        </div>

        <div class="flex-1 overflow-y-auto px-12 md:px-24 pb-32 -mt-12 relative z-10">
            
            <div class="mb-10">
                <div class="text-4xl mb-4">
                    <c:choose>
                        <c:when test="${currentCat != null}"><i class="ph ph-folder-open text-[#4A5D50]"></i></c:when>
                        <c:otherwise><i class="ph ph-tray text-[#4A5D50]"></i></c:otherwise>
                    </c:choose>
                </div>
                <h1 class="text-5xl font-bold text-[#2D332F] mb-3 tracking-tight">
                    <c:forEach var="cat" items="${categoryList}">
                        <c:if test="${currentCat == cat.id}">${cat.name}</c:if>
                    </c:forEach>
                    <c:if test="${currentCat == null}">Inbox</c:if>
                </h1>
                <div class="h-1 w-12 bg-[#4A5D50] rounded-full opacity-20"></div>
            </div>

            <div class="mb-8 relative group">
                <form action="tasks" method="post" class="flex items-center gap-4 pb-2 border-b border-gray-100 focus-within:border-[#4A5D50] transition duration-300">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="currentCat" value="${currentCat}">
                    <i class="ph ph-plus text-xl text-gray-300 group-focus-within:text-[#4A5D50] transition"></i>
                    <input type="text" name="title" placeholder="Write a new task..." required autocomplete="off"
                           class="flex-grow bg-transparent border-none outline-none text-lg placeholder-gray-300 text-[#2D332F] focus:ring-0 p-0 font-medium serif text-2xl">
                    <select name="categoryId" class="text-xs bg-gray-50 hover:bg-gray-100 text-gray-500 py-1 px-3 rounded-full border-none cursor-pointer focus:ring-0 transition outline-none">
                        <option value="" ${currentCat == null ? 'selected' : ''}>Inbox</option>
                        <c:forEach var="cat" items="${categoryList}">
                            <option value="${cat.id}" ${currentCat == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <div class="space-y-2" id="taskListContainer">
                <c:forEach var="task" items="${taskList}">
                    <div class="group flex items-center gap-4 py-3 px-4 bg-white border border-transparent hover:border-[#E6E2D6] hover:shadow-sm rounded-xl transition duration-200" id="task-row-${task.id}">
                        
                        <button onclick="toggleTask(${task.id})" id="btn-${task.id}"
                                class="check-btn w-5 h-5 rounded border-2 flex items-center justify-center shrink-0 cursor-pointer ${task.isCompleted ? 'bg-[#4A5D50] border-[#4A5D50]' : 'border-gray-300 hover:border-[#4A5D50]'}">
                             <i id="icon-${task.id}" class="ph ph-check text-white text-xs ${task.isCompleted ? '' : 'hidden'}"></i>
                        </button>
                        
                        <div class="flex-grow min-w-0">
                            <span id="text-${task.id}" class="task-text text-[16px] block truncate ${task.isCompleted ? 'text-gray-400 line-through decoration-gray-300 serif text-2xl' : 'text-[#2D332F] serif text-2xl'}">
                                ${task.title}
                            </span>
                        </div>

                        <div class="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200">
                            <form action="tasks" method="post">
                                <input type="hidden" name="action" value="updateCategory">
                                <input type="hidden" name="id" value="${task.id}">
                                <input type="hidden" name="currentCat" value="${currentCat}">
                                <select name="newCategoryId" onchange="this.form.submit()" 
                                        class="text-[10px] font-bold tracking-widest uppercase text-gray-400 bg-gray-50 hover:bg-[#E0E6E2] hover:text-[#4A5D50] py-1 px-2 rounded cursor-pointer border-none focus:ring-0 transition outline-none">
                                    <option value="">Inbox</option>
                                    <c:forEach var="cat" items="${categoryList}">
                                        <option value="${cat.id}" ${task.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </form>

                            <form action="tasks" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${task.id}">
                                <input type="hidden" name="currentCat" value="${currentCat}">
                                <button class="w-6 h-6 flex items-center justify-center rounded hover:bg-red-50 text-gray-300 hover:text-red-500 transition">
                                    <i class="ph ph-trash text-lg"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty taskList}">
                    <div class="mt-12 flex flex-col items-center justify-center text-gray-300">
                        <i class="ph ph-wind text-4xl mb-2 opacity-50"></i>
                        <span class="text-sm">Quiet here...</span>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <div id="modalBackdrop" class="hidden fixed inset-0 z-50 bg-[#2D332F]/20 backdrop-blur-sm flex items-center justify-center transition-opacity duration-300">
        <div id="modalCard" class="bg-white w-full max-w-md p-8 rounded-2xl shadow-2xl border border-[#E6E2D6] transform scale-95 transition-transform duration-300">
            <h3 class="serif text-2xl font-bold text-[#2D332F] mb-2">New Page</h3>
            <p class="text-sm text-gray-500 mb-6">Create a new list to organize your tasks.</p>
            <form action="tasks" method="post">
                <input type="hidden" name="action" value="addCategory">
                <div class="mb-6">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Page Name</label>
                    <input type="text" name="categoryName" id="modalInput" required placeholder="e.g. Travel Plans" 
                           class="w-full text-lg border-b border-gray-200 focus:border-[#4A5D50] outline-none focus:ring-0 px-0 py-2 transition bg-transparent placeholder-gray-300 text-[#2D332F] serif text-2xl">
                </div>
                <div class="flex justify-end gap-3">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-sm font-medium text-gray-500 hover:text-gray-800 transition">Cancel</button>
                    <button type="submit" class="px-6 py-2 bg-[#4A5D50] hover:bg-[#3B4A40] text-white text-sm font-medium rounded-lg shadow-lg shadow-[#4A5D50]/20 transition transform hover:-translate-y-0.5">Create Page</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function toggleTask(id) {
            const btn = document.getElementById('btn-' + id);
            const icon = document.getElementById('icon-' + id);
            const text = document.getElementById('text-' + id);
            
            const isCompleted = icon.classList.contains('hidden');
            
            if (isCompleted) {
                btn.classList.remove('border-gray-300', 'hover:border-[#4A5D50]');
                btn.classList.add('bg-[#4A5D50]', 'border-[#4A5D50]');
                icon.classList.remove('hidden');
                text.classList.remove('text-[#2D332F]');
                text.classList.add('text-gray-400', 'line-through', 'decoration-gray-300');
            } else {
                btn.classList.remove('bg-[#4A5D50]', 'border-[#4A5D50]');
                btn.classList.add('border-gray-300', 'hover:border-[#4A5D50]');
                icon.classList.add('hidden');
                text.classList.remove('text-gray-400', 'line-through', 'decoration-gray-300');
                text.classList.add('text-[#2D332F]');
            }

            fetch('tasks', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=toggle&id=' + id
            }).catch(err => console.error('Error:', err));
        }

        const backdrop = document.getElementById('modalBackdrop');
        const card = document.getElementById('modalCard');
        const input = document.getElementById('modalInput');

        function openModal() {
            backdrop.classList.remove('hidden');
            setTimeout(() => {
                card.classList.remove('scale-95');
                card.classList.add('scale-100');
                input.focus();
            }, 10);
        }

        function closeModal() {
            card.classList.remove('scale-100');
            card.classList.add('scale-95');
            setTimeout(() => {
                backdrop.classList.add('hidden');
            }, 150);
        }

        backdrop.addEventListener('click', (e) => { if (e.target === backdrop) closeModal(); });
        document.addEventListener('keydown', (e) => { if (e.key === 'Escape' && !backdrop.classList.contains('hidden')) closeModal(); });
    </script>
</body>
</html>