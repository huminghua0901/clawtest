import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import dotenv from 'dotenv';

dotenv.config();

const prisma = new PrismaClient({
  datasourceUrl: process.env.DATABASE_URL || 'file:./dev.db',
  log: ['error'],
});

async function main() {
  console.log('🌱 Starting database seed...');

  // Check if admin user already exists
  const existingAdmin = await prisma.user.findUnique({
    where: { email: 'admin@blog.local' },
  });

  if (existingAdmin) {
    console.log('✅ Admin user already exists');
  } else {
    // Create default admin user
    const hashedPassword = await bcrypt.hash('admin123', 10);

    const admin = await prisma.user.create({
      data: {
        email: 'admin@blog.local',
        username: 'admin',
        password: hashedPassword,
      },
    });

    console.log('✅ Created admin user:', admin.username);
    console.log('   Email:', admin.email);
    console.log('   Password: admin123 (CHANGE THIS IN PRODUCTION!)');
  }

  // Create sample categories
  const categories = [
    { name: 'Technology', slug: 'technology', description: 'Tech articles and tutorials' },
    { name: 'Development', slug: 'development', description: 'Programming and coding' },
    { name: 'Design', slug: 'design', description: 'UI/UX and design' },
  ];

  for (const cat of categories) {
    const existing = await prisma.category.findUnique({
      where: { slug: cat.slug },
    });

    if (!existing) {
      await prisma.category.create({ data: cat });
      console.log(`✅ Created category: ${cat.name}`);
    }
  }

  // Create sample tags
  const tags = ['Next.js', 'React', 'TypeScript', 'Node.js', 'Prisma', 'Tutorial'];

  for (const tag of tags) {
    const slug = tag.toLowerCase().replace(/\s+/g, '-');
    const existing = await prisma.tag.findUnique({
      where: { slug },
    });

    if (!existing) {
      await prisma.tag.create({ data: { name: tag, slug } });
      console.log(`✅ Created tag: ${tag}`);
    }
  }

  console.log('\n🎉 Database seeded successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error seeding database:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
