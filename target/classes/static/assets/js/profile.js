/**
 * User Profile Management
 * Handles fetching and displaying user profile data
 */

const UserProfile = {
    // API Configuration
    api: {
        profile: (window.CONTEXT_PATH || '') + '/api/users/profile',
        update: (window.CONTEXT_PATH || '') + '/api/users'
    },

    // Initialization
    init() {
        console.log('[UserProfile] Initializing...');
        this.loadProfile();
        this.bindEvents();
    },

    // Bind UI Events
    bindEvents() {
        // Edit buttons
        document.getElementById('editProfileBtn')?.addEventListener('click', () => this.showNotification('Edit profile feature coming soon', 'info'));
        document.getElementById('editAccountBtn')?.addEventListener('click', () => this.showNotification('Edit account feature coming soon', 'info'));
        document.getElementById('editAddressBtn')?.addEventListener('click', () => this.showNotification('Edit address feature coming soon', 'info'));
        
        // Security switches
        document.querySelectorAll('.custom-switch').forEach(switchEl => {
            switchEl.addEventListener('click', function() {
                this.classList.toggle('active');
                // Future: Call API to update setting
                console.log('Toggled setting:', this.id, this.classList.contains('active'));
            });
        });
    },

    // Load Profile Data from API
    async loadProfile() {
        try {
            console.log('[UserProfile] Fetching profile data...');
            this.setLoadingState(true);

            const response = await fetch(this.api.profile, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            const result = await response.json();
            console.log('[UserProfile] Data received:', result);
            
            if (result.status !== 'error') {
                // Handle different response structures (direct object or wrapped in data)
                const data = result.data || result; 
                this.populateProfile(data);
            } else {
                console.error('[UserProfile] API Error:', result.message);
                this.showNotification('Failed to load profile data', 'error');
            }

        } catch (error) {
            console.error('[UserProfile] Fetch Error:', error);
            this.showNotification('Network error loading profile', 'error');
        } finally {
            this.setLoadingState(false);
        }
    },

    // Populate UI with Data
    populateProfile(data) {
        if (!data) return;

        // Helper to safely set text content
        const setText = (id, value, fallback = 'N/A') => {
            const el = document.getElementById(id);
            if (el) el.textContent = value || fallback;
        };

        // --- Personal Info ---
        setText('pf_full_name', data.full_name);
        setText('pf_full_name_2', data.full_name);
        setText('pf_title_2', `${data.title || ''} ${data.role || ''}`);
        
        // --- Account Info ---
        setText('pf_status', data.status);
        setText('pf_status_2', data.status);
        setText('pf_role', data.role);
        setText('pf_email', data.email);
        setText('pf_username', data.username);
        setText('pf_phone', `${data.country_code || ''} ${data.phone_number || ''}`);
        setText('pf_gender', data.gender);
        setText('pf_level', `Level ${data.level || 1}`);
        setText('pf_unique_id_display', `ID: ${data.unique_id || 'N/A'}`);
        
        // --- Address Info ---
        setText('pf_address', data.address);
        setText('pf_city', data.city);
        setText('pf_state', data.state);
        setText('pf_zip', data.zip_code);
        setText('pf_country', data.country);
        setText('pf_nationality', data.nationality);

        // --- Organization Info ---
        // Note: The API might return organization details nested or flat
        // Adjusting based on common patterns, assuming flat or 'organization' object
        const org = data.organization || data;
        setText('pf_org_name', org.org_name || data.org_name);
        setText('pf_org_code', org.org_code || data.org_code);
        setText('pf_org_sub_type', org.subscription_type);
        setText('pf_org_sub_start', this.formatDate(org.subscription_start_date));
        setText('pf_org_sub_end', this.formatDate(org.subscription_end_date));

        // --- Dates ---
        setText('pf_created', this.formatDate(data.created_at || data.created_date));
        setText('pf_last_login', this.formatDate(data.last_login));

        // --- Avatar ---
        const avatarImg = document.getElementById('pf_avatar');
        if (avatarImg && data.avatar_url) {
            avatarImg.src = data.avatar_url;
        }

        // --- Security Toggles ---
        // Set initial state of switches based on data
        this.setSwitchState('twoFactorSMS', data.two_factor_auth && data.two_factor_method === 'sms');
        this.setSwitchState('twoFactorEmail', data.two_factor_auth && data.two_factor_method === 'email');
        this.setSwitchState('loginNotifications', data.login_notification);
    },

    setSwitchState(id, isActive) {
        const el = document.getElementById(id);
        if (el) {
            if (isActive) el.classList.add('active');
            else el.classList.remove('active');
        }
    },

    setLoadingState(isLoading) {
        const loadingText = isLoading ? 'Loading...' : 'N/A';
        const elementsToToggle = ['pf_full_name', 'pf_email', 'pf_phone', 'pf_address'];
        
        if (isLoading) {
            // Optional: Add a loading class or skeleton state
            document.body.style.cursor = 'wait';
        } else {
            document.body.style.cursor = 'default';
        }
    },

    formatDate(dateStr) {
        if (!dateStr) return 'N/A';
        try {
            return new Date(dateStr).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        } catch (e) {
            return dateStr;
        }
    },

    showNotification(message, type = 'info') {
        // Fallback or integration with existing notification system
        console.log(`[${type.toUpperCase()}] ${message}`);
        if (typeof showNotification === 'function') {
            showNotification(message, type);
        } else {
            // Simple alert for now if no toast library
            // alert(message);
        }
    }
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    UserProfile.init();
});
