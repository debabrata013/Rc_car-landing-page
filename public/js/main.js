// Main JavaScript file for RC Car Landing Page

document.addEventListener('DOMContentLoaded', () => {
  console.log('RC Car Landing Page Loaded');
  
  // Smooth scrolling for navigation links
  const navLinks = document.querySelectorAll('.nav-links a');
  
  navLinks.forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      
      const targetId = this.getAttribute('href');
      const targetSection = document.querySelector(targetId);
      
      if (targetSection) {
        window.scrollTo({
          top: targetSection.offsetTop - 80,
          behavior: 'smooth'
        });
      }
    });
  });
  
  // Contact form handling
  const contactForm = document.getElementById('contact-form');
  
  if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      // Form validation and submission logic would go here
      console.log('Form submitted');
      
      // Reset form after submission
      this.reset();
      
      // Show success message
      alert('Thank you for your message! We will get back to you soon.');
    });
  }
});
