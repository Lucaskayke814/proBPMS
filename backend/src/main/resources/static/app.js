// ===== CONFIG =====
const API_URL = '/api/v1';
const TOKEN_KEY = 'accessToken';
const USER_EMAIL_KEY = 'userEmail';

// ===== AUTH =====
function login(e) {
  e.preventDefault();
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;
  
  fetch(`${API_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
  })
  .then(r => r.json())
  .then(data => {
    if (data.accessToken) {
      localStorage.setItem(TOKEN_KEY, data.accessToken);
      localStorage.setItem(USER_EMAIL_KEY, email);
      showApp();
      loadDashboard();
    } else {
      showError('Falha ao fazer login');
    }
  })
  .catch(err => showError(err.message));
}

function logout() {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(USER_EMAIL_KEY);
  document.getElementById('authPanel').classList.add('active');
  document.getElementById('appShell').classList.remove('active');
  document.getElementById('loginForm').reset();
}

function showError(msg) {
  const status = document.getElementById('authStatus');
  status.textContent = msg;
  status.classList.add('error');
}

function isLoggedIn() {
  return localStorage.getItem(TOKEN_KEY) !== null;
}

function getAuthHeaders() {
  return {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${localStorage.getItem(TOKEN_KEY)}`
  };
}

// ===== UI =====
function showApp() {
  document.getElementById('authPanel').classList.remove('active');
  document.getElementById('appShell').classList.add('active');
  const email = localStorage.getItem(USER_EMAIL_KEY);
  document.getElementById('userEmail').textContent = email;
  if (email) {
    document.getElementById('userAvatar').textContent = email.charAt(0).toUpperCase();
  }
}

function switchTab(tabName) {
  // Hide all tabs
  document.querySelectorAll('.tab-content').forEach(tab => {
    tab.classList.remove('active');
  });
  
  // Show selected tab
  const tab = document.getElementById(tabName);
  if (tab) tab.classList.add('active');
  
  // Update nav items
  document.querySelectorAll('.nav-item').forEach(item => {
    item.classList.remove('active');
  });
  document.querySelector(`[data-tab="${tabName}"]`)?.classList.add('active');
  
  // Update page title
  const titles = {
    dashboard: 'Dashboard',
    contracts: 'Contratos',
    agencies: 'Órgãos Anuentes',
    demands: 'Demandas',
    financial: 'Financeiro',
    operational: 'Operacional'
  };
  document.getElementById('pageTitle').textContent = titles[tabName] || 'proBPMS';
  
  // Load tab content
  if (tabName === 'contracts') loadContracts();
  else if (tabName === 'agencies') loadAgencies();
}

// ===== DASHBOARD =====
function loadDashboard() {
  // Check API health
  fetch(`${API_URL}/health`)
    .catch(() => {
      document.querySelector('[data-tab="dashboard"] .card:first-child .value').textContent = '✗';
    });
  
  // Load counts
  Promise.all([
    fetch(`${API_URL}/contracts`, { headers: getAuthHeaders() }).then(r => r.json()),
    fetch(`${API_URL}/agencies`, { headers: getAuthHeaders() }).then(r => r.json()),
    fetch(`${API_URL}/operational/dashboard`, { headers: getAuthHeaders() }).then(r => r.json())
  ])
  .then(([contracts, agencies, operational]) => {
    document.getElementById('countContracts').textContent = Array.isArray(contracts) ? contracts.length : 0;
    document.getElementById('countAgencies').textContent = Array.isArray(agencies) ? agencies.length : 0;
    document.getElementById('countDemands').textContent = operational?.totalDemands || 0;
  })
  .catch(err => console.error('Dashboard load error:', err));
}

// ===== CONTRACTS =====
function loadContracts() {
  fetch(`${API_URL}/contracts`, { headers: getAuthHeaders() })
    .then(r => r.json())
    .then(data => {
      const table = document.getElementById('contractsTable');
      if (!data || data.length === 0) {
        table.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 40px;">Nenhum contrato cadastrado</td></tr>';
        return;
      }
      
      table.innerHTML = data.map(c => `
        <tr>
          <td>${c.number || '—'}</td>
          <td>${c.year || '—'}</td>
          <td>${c.description || '—'}</td>
          <td>${formatCurrency(c.totalAmount || 0)}</td>
          <td><span class="badge ${getStatusBadge(c.status)}">${c.status || 'N/A'}</span></td>
          <td>
            <button class="btn sm" onclick="editContract('${c.id}')">Editar</button>
            <button class="btn sm danger" onclick="deleteContract('${c.id}')">Deletar</button>
          </td>
        </tr>
      `).join('');
    })
    .catch(err => console.error('Load contracts error:', err));
}

function openContractModal() {
  document.getElementById('contractForm').reset();
  document.getElementById('contractModalTitle').textContent = 'Novo Contrato';
  document.getElementById('contractModal').classList.add('active');
  contractEditId = null;
}

function closeContractModal() {
  document.getElementById('contractModal').classList.remove('active');
}

let contractEditId = null;

document.getElementById('contractForm')?.addEventListener('submit', function(e) {
  e.preventDefault();
  
  const data = {
    number: document.getElementById('contractNumber').value,
    year: parseInt(document.getElementById('contractYear').value),
    description: document.getElementById('contractDescription').value,
    supplierName: document.getElementById('contractSupplier').value,
    totalAmount: parseFloat(document.getElementById('contractTotal').value),
    status: document.getElementById('contractStatus').value,
    startDate: document.getElementById('contractStart').value || null,
    endsOn: document.getElementById('contractEnd').value || null,
    managerName: document.getElementById('contractManager').value || null,
    fiscalName: document.getElementById('contractFiscal').value || null,
    notes: document.getElementById('contractNotes').value || null
  };
  
  const method = contractEditId ? 'PATCH' : 'POST';
  const url = contractEditId ? `${API_URL}/contracts/${contractEditId}` : `${API_URL}/contracts`;
  
  fetch(url, {
    method,
    headers: getAuthHeaders(),
    body: JSON.stringify(data)
  })
  .then(r => r.json())
  .then(() => {
    closeContractModal();
    loadContracts();
  })
  .catch(err => alert('Erro: ' + err.message));
});

function editContract(id) {
  fetch(`${API_URL}/contracts/${id}`, { headers: getAuthHeaders() })
    .then(r => r.json())
    .then(c => {
      contractEditId = id;
      document.getElementById('contractNumber').value = c.number || '';
      document.getElementById('contractYear').value = c.year || '';
      document.getElementById('contractDescription').value = c.description || '';
      document.getElementById('contractSupplier').value = c.supplierName || '';
      document.getElementById('contractTotal').value = c.totalAmount || '';
      document.getElementById('contractStatus').value = c.status || '';
      document.getElementById('contractStart').value = c.startDate || '';
      document.getElementById('contractEnd').value = c.endsOn || '';
      document.getElementById('contractManager').value = c.managerName || '';
      document.getElementById('contractFiscal').value = c.fiscalName || '';
      document.getElementById('contractNotes').value = c.notes || '';
      document.getElementById('contractModalTitle').textContent = 'Editar Contrato';
      document.getElementById('contractModal').classList.add('active');
    });
}

function deleteContract(id) {
  if (!confirm('Tem certeza que deseja deletar este contrato?')) return;
  
  fetch(`${API_URL}/contracts/${id}`, {
    method: 'DELETE',
    headers: getAuthHeaders()
  })
  .then(() => loadContracts())
  .catch(err => alert('Erro: ' + err.message));
}

// ===== AGENCIES =====
function loadAgencies() {
  fetch(`${API_URL}/agencies`, { headers: getAuthHeaders() })
    .then(r => r.json())
    .then(data => {
      const table = document.getElementById('agenciesTable');
      if (!data || data.length === 0) {
        table.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 40px;">Nenhum órgão cadastrado</td></tr>';
        return;
      }
      
      table.innerHTML = data.map(a => `
        <tr>
          <td>${a.name || '—'}</td>
          <td>${a.acronym || '—'}</td>
          <td>${a.contactName || '—'}</td>
          <td>${a.email || '—'}</td>
          <td>
            <button class="btn sm" onclick="editAgency('${a.id}')">Editar</button>
            <button class="btn sm danger" onclick="deleteAgency('${a.id}')">Deletar</button>
          </td>
        </tr>
      `).join('');
    })
    .catch(err => console.error('Load agencies error:', err));
}

function openAgencyModal() {
  document.getElementById('agencyForm').reset();
  document.getElementById('agencyModalTitle').textContent = 'Novo Órgão Anuente';
  document.getElementById('agencyModal').classList.add('active');
  agencyEditId = null;
}

function closeAgencyModal() {
  document.getElementById('agencyModal').classList.remove('active');
}

let agencyEditId = null;

document.getElementById('agencyForm')?.addEventListener('submit', function(e) {
  e.preventDefault();
  
  const data = {
    name: document.getElementById('agencyName').value,
    acronym: document.getElementById('agencyAcronym').value,
    phone: document.getElementById('agencyPhone').value || null,
    contactName: document.getElementById('agencyContact').value || null,
    email: document.getElementById('agencyEmail').value || null,
    availableAmount: parseFloat(document.getElementById('agencyAmount').value || 0),
    notes: document.getElementById('agencyNotes').value || null
  };
  
  const method = agencyEditId ? 'PATCH' : 'POST';
  const url = agencyEditId ? `${API_URL}/agencies/${agencyEditId}` : `${API_URL}/agencies`;
  
  fetch(url, {
    method,
    headers: getAuthHeaders(),
    body: JSON.stringify(data)
  })
  .then(r => r.json())
  .then(() => {
    closeAgencyModal();
    loadAgencies();
  })
  .catch(err => alert('Erro: ' + err.message));
});

function editAgency(id) {
  fetch(`${API_URL}/agencies/${id}`, { headers: getAuthHeaders() })
    .then(r => r.json())
    .then(a => {
      agencyEditId = id;
      document.getElementById('agencyName').value = a.name || '';
      document.getElementById('agencyAcronym').value = a.acronym || '';
      document.getElementById('agencyPhone').value = a.phone || '';
      document.getElementById('agencyContact').value = a.contactName || '';
      document.getElementById('agencyEmail').value = a.email || '';
      document.getElementById('agencyAmount').value = a.availableAmount || '';
      document.getElementById('agencyNotes').value = a.notes || '';
      document.getElementById('agencyModalTitle').textContent = 'Editar Órgão Anuente';
      document.getElementById('agencyModal').classList.add('active');
    });
}

function deleteAgency(id) {
  if (!confirm('Tem certeza que deseja deletar este órgão?')) return;
  
  fetch(`${API_URL}/agencies/${id}`, {
    method: 'DELETE',
    headers: getAuthHeaders()
  })
  .then(() => loadAgencies())
  .catch(err => alert('Erro: ' + err.message));
}

// ===== UTILITIES =====
function formatCurrency(value) {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL'
  }).format(value);
}

function getStatusBadge(status) {
  const map = {
    'ACTIVE': 'success',
    'PAUSED': 'warning',
    'FINISHED': 'danger'
  };
  return map[status] || 'warning';
}

// ===== INIT =====
document.addEventListener('DOMContentLoaded', function() {
  // Login form
  document.getElementById('loginForm')?.addEventListener('submit', login);
  
  // Logout
  document.getElementById('logoutBtn')?.addEventListener('click', logout);
  
  // Navigation
  document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', function(e) {
      if (this.dataset.tab) {
        e.preventDefault();
        switchTab(this.dataset.tab);
      }
    });
  });
  
  // Modal close on background click
  document.getElementById('contractModal')?.addEventListener('click', function(e) {
    if (e.target === this) closeContractModal();
  });
  
  document.getElementById('agencyModal')?.addEventListener('click', function(e) {
    if (e.target === this) closeAgencyModal();
  });
  
  // Show app if already logged in
  if (isLoggedIn()) {
    showApp();
    loadDashboard();
  }
});
