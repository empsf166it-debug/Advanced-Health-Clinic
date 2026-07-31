const fs = require('fs');
const path = require('path');

const dir = 'c:\\Users\\Shalani A\\Documents\\Shalan\\Own Websites(August)\\Advanced Health Clinic';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Replace names
    content = content.replace(/Advanced Health Clinic/g, 'Mediora');
    content = content.replace(/Advanced Health/g, 'Mediora');
    
    // Replace URL instances
    content = content.replace(/advancedhealthclinic\.com/g, 'mediora.com');
    
    // Insert favicon
    if (!content.includes('favicon.svg')) {
        content = content.replace(/<\/title>/g, '</title>\n    <link rel="icon" href="favicon.svg" type="image/svg+xml">');
    }
    
    fs.writeFileSync(filePath, content);
});

console.log('Rebrand completed successfully for ' + files.length + ' files.');
