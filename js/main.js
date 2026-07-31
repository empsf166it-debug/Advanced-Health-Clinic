document.addEventListener('DOMContentLoaded', () => {
    // Theme Toggle
    const themeToggle = document.querySelector('.theme-toggle');
    const html = document.documentElement;
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

    const setTheme = (isDark) => {
        if (isDark) {
            html.setAttribute('data-theme', 'dark');
            if(themeToggle) themeToggle.innerHTML = '<i class="fa-solid fa-sun"></i>';
            localStorage.setItem('theme', 'dark');
        } else {
            html.removeAttribute('data-theme');
            if(themeToggle) themeToggle.innerHTML = '<i class="fa-solid fa-moon"></i>';
            localStorage.setItem('theme', 'light');
        }
    };

    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        setTheme(savedTheme === 'dark');
    } else {
        setTheme(prefersDark.matches);
    }

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            const isDark = html.hasAttribute('data-theme');
            setTheme(!isDark);
        });
    }

    // Language / RTL Toggle
    const langToggle = document.querySelector('.lang-toggle');
    if (langToggle) {
        // Initialize from local storage
        const savedLang = localStorage.getItem('lang');
        if (savedLang === 'ar') {
            html.setAttribute('dir', 'rtl');
            html.setAttribute('lang', 'ar');
        }

        langToggle.addEventListener('click', () => {
            const currentDir = html.getAttribute('dir') || 'ltr';
            if (currentDir === 'ltr') {
                html.setAttribute('dir', 'rtl');
                html.setAttribute('lang', 'ar');
                localStorage.setItem('lang', 'ar');
            } else {
                html.setAttribute('dir', 'ltr');
                html.setAttribute('lang', 'en');
                localStorage.setItem('lang', 'en');
            }
        });
    }

    // Sticky Header
    const header = document.querySelector('.header');
    if (header) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }

    // Mobile Menu Toggle
    const mobileToggle = document.querySelector('.mobile-toggle');
    const navMenu = document.querySelector('.nav-menu');
    if (mobileToggle && navMenu) {
        mobileToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            const icon = mobileToggle.querySelector('i');
            if (navMenu.classList.contains('active')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-xmark');
            } else {
                icon.classList.remove('fa-xmark');
                icon.classList.add('fa-bars');
            }
        });
    }

    // Back to top button
    const backToTop = document.getElementById('backToTop');
    if (backToTop) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 300) {
                backToTop.style.display = 'flex';
            } else {
                backToTop.style.display = 'none';
            }
        });
        backToTop.addEventListener('click', () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }
});
