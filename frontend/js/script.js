// Filtrar clientes por nome
function filtrarClientes() {
    const filtro = document.getElementById('filtroCliente').value.toLowerCase();
    const linhas = document.querySelectorAll('#tabelaClientes tbody tr');
  
    linhas.forEach((linha) => {
      const nome = linha.querySelector('td:nth-child(2)').textContent.toLowerCase();
      linha.style.display = nome.includes(filtro) ? '' : 'none';
    });
  }
  
  // Filtrar atendimentos por nome ou data
  function filtrarAtendimentos() {
    const filtroNome = document.getElementById('filtroAtendimentoNome').value.toLowerCase();
    const filtroData = document.getElementById('filtroAtendimentoData').value;
    const linhas = document.querySelectorAll('#tabelaAtendimentos tbody tr');
  
    linhas.forEach((linha) => {
      const nome = linha.querySelector('td:nth-child(2)').textContent.toLowerCase();
      const data = linha.querySelector('td:nth-child(3)').textContent;
  
      const mostrar = (!filtroNome || nome.includes(filtroNome)) &&
                      (!filtroData || data === filtroData);
      linha.style.display = mostrar ? '' : 'none';
    });
  }
  
  // Exportar tabela para PDF
  function exportarPDF(tabelaId, titulo) {
    const tabela = document.getElementById(tabelaId);
    const rows = Array.from(tabela.querySelectorAll('tr'));
    let conteudo = `${titulo}\n\n`;
  
    rows.forEach((row) => {
      const cells = Array.from(row.querySelectorAll('th, td'));
      conteudo += cells.map(cell => cell.textContent).join(' | ') + '\n';
    });
  
    const blob = new Blob([conteudo], { type: 'application/pdf' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `${titulo}.pdf`;
    link.click();
  }

  // Carregar opções de clientes no formulário de atendimentos
  function carregarClientes() {
    const selectCliente = document.getElementById('clienteAtendimento');
    fetch('/api/clientes') // Supondo que exista um endpoint para listar clientes
      .then(response => response.json())
      .then(clientes => {
        clientes.forEach(cliente => {
          const option = document.createElement('option');
          option.value = cliente.id;
          option.textContent = cliente.nome;
          selectCliente.appendChild(option);
        });
      })
      .catch(error => console.error('Erro ao carregar clientes:', error));
  }
  
  // Executar ao carregar a página
  if (document.getElementById('clienteAtendimento')) {
    carregarClientes();
  }
  