// Smooth scroll for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href !== '#' && href.startsWith('#')) {
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        }
    });
});

// Navbar background on scroll
const nav = document.querySelector('.nav');
let lastScroll = 0;

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 100) {
        nav.style.boxShadow = '0 4px 6px rgba(0,0,0,0.1)';
    } else {
        nav.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
    }
    
    lastScroll = currentScroll;
});

// Animate elements on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all feature cards and doc cards
document.querySelectorAll('.feature-card, .doc-card, .download-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Add typing animation to textarea in hero
const textarea = document.querySelector('.app-textarea');
if (textarea) {
    const text = textarea.value;
    textarea.value = '';
    let index = 0;
    
    const typeWriter = () => {
        if (index < text.length) {
            textarea.value += text.charAt(index);
            index++;
            setTimeout(typeWriter, 50);
        }
    };
    
    // Start typing after a short delay
    setTimeout(typeWriter, 1000);
}

// Track download clicks (for analytics if needed)
document.querySelectorAll('a[href*="download"], a[href*=".deb"]').forEach(link => {
    link.addEventListener('click', (e) => {
        // Could add analytics tracking here
        console.log('Download initiated:', link.href);
    });
});

// Add copy button functionality to code blocks
document.querySelectorAll('pre code').forEach(block => {
    const button = document.createElement('button');
    button.innerHTML = '📋 Copy';
    button.className = 'copy-button';
    button.style.cssText = `
        position: absolute;
        top: 8px;
        right: 8px;
        padding: 6px 12px;
        background: rgba(255,255,255,0.2);
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 4px;
        color: white;
        cursor: pointer;
        font-size: 0.85rem;
        transition: all 0.3s ease;
    `;
    
    const pre = block.parentElement;
    pre.style.position = 'relative';
    pre.appendChild(button);
    
    button.addEventListener('click', async () => {
        const text = block.textContent;
        try {
            await navigator.clipboard.writeText(text);
            button.innerHTML = '✅ Copied!';
            button.style.background = 'rgba(80, 200, 120, 0.3)';
            setTimeout(() => {
                button.innerHTML = '📋 Copy';
                button.style.background = 'rgba(255,255,255,0.2)';
            }, 2000);
        } catch (err) {
            console.error('Failed to copy:', err);
            button.innerHTML = '❌ Failed';
            setTimeout(() => {
                button.innerHTML = '📋 Copy';
            }, 2000);
        }
    });
    
    button.addEventListener('mouseenter', () => {
        button.style.background = 'rgba(255,255,255,0.3)';
    });
    
    button.addEventListener('mouseleave', () => {
        if (!button.innerHTML.includes('Copied') && !button.innerHTML.includes('Failed')) {
            button.style.background = 'rgba(255,255,255,0.2)';
        }
    });
});

// Add platform detection
const getPlatform = () => {
    const userAgent = navigator.userAgent.toLowerCase();
    if (userAgent.indexOf('linux') !== -1) return 'linux';
    if (userAgent.indexOf('win') !== -1) return 'windows';
    if (userAgent.indexOf('mac') !== -1) return 'macos';
    return 'other';
};

// Highlight appropriate download option based on platform
const platform = getPlatform();
if (platform === 'linux') {
    const debCard = document.querySelector('.download-card.featured');
    if (debCard && !debCard.querySelector('.platform-badge')) {
        const badge = document.createElement('div');
        badge.className = 'platform-badge';
        badge.innerHTML = '💻 Recommended for your system';
        badge.style.cssText = `
            margin-top: 1rem;
            padding: 8px 12px;
            background: rgba(80, 200, 120, 0.2);
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            color: #2d7a4d;
            text-align: center;
        `;
        debCard.appendChild(badge);
    }
}

// Add scroll-to-top button
const createScrollToTop = () => {
    const button = document.createElement('button');
    button.innerHTML = '↑';
    button.className = 'scroll-to-top';
    button.style.cssText = `
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: var(--primary-color);
        color: white;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        z-index: 999;
    `;
    
    document.body.appendChild(button);
    
    window.addEventListener('scroll', () => {
        if (window.pageYOffset > 500) {
            button.style.opacity = '1';
            button.style.visibility = 'visible';
        } else {
            button.style.opacity = '0';
            button.style.visibility = 'hidden';
        }
    });
    
    button.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
    
    button.addEventListener('mouseenter', () => {
        button.style.transform = 'scale(1.1)';
        button.style.background = 'var(--primary-dark)';
    });
    
    button.addEventListener('mouseleave', () => {
        button.style.transform = 'scale(1)';
        button.style.background = 'var(--primary-color)';
    });
};

createScrollToTop();

// Add keyboard navigation (Esc to close details)
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        document.querySelectorAll('details[open]').forEach(details => {
            details.removeAttribute('open');
        });
    }
});

// Preload images for better performance
const preloadImages = () => {
    const images = [
        'https://raw.githubusercontent.com/scriptor-pro/memo-tori/main/assets/icon.png'
    ];
    
    images.forEach(src => {
        const img = new Image();
        img.src = src;
    });
};

preloadImages();

// Console Easter egg
console.log('%cMemo Tori 🐦', 'font-size: 2rem; font-weight: bold; color: #4A90E2;');
console.log('%cCapture ideas instantly!', 'font-size: 1.2rem; color: #50C878;');
console.log('%cGitHub: https://github.com/scriptor-pro/memo-tori', 'color: #666;');
console.log('%cVersion: 0.1.4 "Beaufix"', 'color: #666;');

// Log page load time
window.addEventListener('load', () => {
    const loadTime = performance.now();
    console.log(`Page loaded in ${loadTime.toFixed(2)}ms`);
});
