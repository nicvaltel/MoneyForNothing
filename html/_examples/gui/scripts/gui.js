// Configuration
const resizeFlag = true; // Set to false to disable resizing

// Initialize windows
const window1 = document.getElementById('window1');
const window2 = document.getElementById('window2');

// Set initial positions if not already positioned
if (!window1.style.left) window1.style.left = '100px';
if (!window1.style.top) window1.style.top = '100px';
if (!window2.style.left) window2.style.left = '450px';
if (!window2.style.top) window2.style.top = '200px';

// Make all windows draggable
document.querySelectorAll('.window').forEach(windowElement => {
    if (resizeFlag) {
        windowElement.classList.add('resizable');
    }
    
    const titleBar = windowElement.querySelector('.title-bar');
    let isDragging = false;
    let offsetX, offsetY;
    
    titleBar.addEventListener('mousedown', (e) => {
        isDragging = true;
        offsetX = e.clientX - windowElement.getBoundingClientRect().left;
        offsetY = e.clientY - windowElement.getBoundingClientRect().top;
        windowElement.style.cursor = 'grabbing';
        
        // Bring window to front
        document.querySelectorAll('.window').forEach(w => {
            w.style.zIndex = 100;
        });
        windowElement.style.zIndex = 200;
    });
    
    document.addEventListener('mousemove', (e) => {
        if (!isDragging) return;
        
        windowElement.style.left = (e.clientX - offsetX) + 'px';
        windowElement.style.top = (e.clientY - offsetY) + 'px';
    });
    
    document.addEventListener('mouseup', () => {
        isDragging = false;
        windowElement.style.cursor = 'default';
    });
});

// Close button functionality for all windows
document.querySelectorAll('.close-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        const windowId = e.target.getAttribute('data-window');
        document.getElementById(windowId).style.display = 'none';
        updateFooterButtons();
    });
});

// Tab switching functionality for Window 2
document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', (e) => {
        const tabId = e.target.getAttribute('data-tab');
        
        // Deactivate all tabs and contents
        document.querySelectorAll('.tab').forEach(t => {
            t.classList.remove('active');
        });
        document.querySelectorAll('.tab-content').forEach(c => {
            c.classList.remove('active');
        });
        
        // Activate selected tab
        e.target.classList.add('active');
        document.getElementById(tabId).classList.add('active');
    });
});

// Button click handlers for Window 1
document.querySelectorAll('[data-window="window1"].btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        const btnText = e.target.textContent;
        alert(`Window 1: ${btnText} was clicked!`);
    });
});

// Button click handlers for Window 2
document.querySelectorAll('[data-window="window2"].btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        const btnText = e.target.textContent;
        const tabId = e.target.getAttribute('data-tab');
        alert(`Window 2 (${tabId}): ${btnText} was clicked!`);
    });
});

// Custom resize handling
if (resizeFlag) {
    document.querySelectorAll('.resize-handle').forEach(handle => {
        handle.addEventListener('mousedown', initResize);
    });
    
    function initResize(e) {
        e.preventDefault();
        const windowElement = this.parentElement;
        const startX = e.clientX;
        const startY = e.clientY;
        const startWidth = parseInt(document.defaultView.getComputedStyle(windowElement).width, 10);
        const startHeight = parseInt(document.defaultView.getComputedStyle(windowElement).height, 10);
        
        function doResize(e) {
            windowElement.style.width = (startWidth + e.clientX - startX) + 'px';
            windowElement.style.height = (startHeight + e.clientY - startY) + 'px';
        }
        
        function stopResize() {
            window.removeEventListener('mousemove', doResize, false);
            window.removeEventListener('mouseup', stopResize, false);
        }
        
        window.addEventListener('mousemove', doResize, false);
        window.addEventListener('mouseup', stopResize, false);
    }
} else {
    document.querySelectorAll('.resize-handle').forEach(handle => {
        handle.style.display = 'none';
    });
}

// Toggle window visibility functions
function toggleWindow(windowId) {
    const windowElement = document.getElementById(windowId);
    if (windowElement.style.display === 'block') {
        windowElement.style.display = 'none';
    } else {
        windowElement.style.display = 'block';
        // Bring to front
        document.querySelectorAll('.window').forEach(w => {
            w.style.zIndex = 100;
        });
        windowElement.style.zIndex = 200;
    }
    updateFooterButtons();
}

function updateFooterButtons() {
    document.getElementById('toggleWindow1').textContent = 
        window1.style.display === 'block' ? 'Hide Window 1' : 'Show Window 1';
    document.getElementById('toggleWindow2').textContent = 
        window2.style.display === 'block' ? 'Hide Window 2' : 'Show Window 2';
}

// Footer button event listeners
document.getElementById('toggleWindow1').addEventListener('click', () => toggleWindow('window1'));
document.getElementById('toggleWindow2').addEventListener('click', () => toggleWindow('window2'));

// Initialize footer buttons
updateFooterButtons();